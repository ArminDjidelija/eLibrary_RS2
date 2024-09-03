using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;

namespace eLibrary.Services.Recommender
{
    public class MlRecommenderService : IRecommendService
    {
        private readonly IMapper mapper;
        private readonly ELibraryContext eLibraryContext;
        public List<int> allAuthors { get; set; }
        public List<int> allTargetGroups { get; set; }
        public List<int> allContentTypes { get; set; }
        public List<int> allLanguages { get; set; }
        public List<int> allVrsteGrade { get; set; }

        public MlRecommenderService(ELibraryContext eLibraryContext, IMapper mapper)
        {
            this.eLibraryContext = eLibraryContext;
            this.mapper = mapper;
        }
        
        /// <summary>
        /// Recommender is consisted of nested for loop where we calculate book similarity with cosine similarity.
        /// We group every two books (we don't group same books) which are more than 75% similar.
        /// Similarity is based on comparing authors, genres, target groups, language, and type of book.
        /// Books that are similar are grouped and inserted into data list.
        /// After data training, we can consume the model.
        /// We have the list of books user has previously read. 
        /// We get most similar books based on books user has already viewed.
        /// </summary>
        float threshold = 0.65f;
        static MLContext mlContext = null;
        static object isLocked = new object();
        const string ModelPath = "model.zip";
        static ITransformer model = null;
        public async Task<List<Model.KnjigeDTOs.Knjige>> GetRecommendedBooks(int citalacId)
        {
            if (model == null)
            {
                await LoadAllData();
               
                lock (isLocked)
                {
                    mlContext = new MLContext();

                    if (File.Exists(ModelPath))
                    {
                        // Load the model from the file
                        using (var stream = new FileStream(ModelPath, FileMode.Open, FileAccess.Read, FileShare.Read))
                        {
                            model = mlContext.Model.Load(stream, out var modelInputSchema);
                        }
                    }
                    else
                    {
                        TrainData();
                    }
                    
                }
            }

            var readedBooks = eLibraryContext
                .CitalacKnjigaLogs
                .Where(x=> x.CitalacId == citalacId)
                .Select(x=> x.KnjigaId)
                .Distinct()
                .ToList();

            var knjiges = eLibraryContext
                .Knjiges
                .ToList();

            var predictionResult = new List<(Database.Knjige, float)>();

            foreach (var knjiga in knjiges)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<KnjigaEntry, Copurchase_prediction>(model);

                foreach(var procitanaKnjiga in readedBooks)
                {
                    if (procitanaKnjiga == knjiga.KnjigaId)
                        continue;

                    var prediction = predictionengine.Predict(
                                         new KnjigaEntry()
                                         {
                                             KnjigaId = (uint)procitanaKnjiga,
                                             CoSimilarKnjigaId = (uint)knjiga.KnjigaId
                                         });
                    predictionResult.Add(new(knjiga, prediction.Score));
                }
            }

            var proba = predictionResult
                .OrderByDescending(x => x.Item2)
                .Distinct()
                .Take(30)
                .ToList();


            var finalResult = predictionResult
                .OrderByDescending(x => x.Item2)
                .Select(x => x.Item1)
                .Distinct()
                .Where(x=> !readedBooks.Any(y=>x.KnjigaId==y))
                .Take(5)
                .ToList();

            var data1 = mapper.Map<List<Model.KnjigeDTOs.Knjige>>(finalResult);
            return data1;
        }

        public double ComputeCosineSimilarity(Database.Knjige book1, Database.Knjige book2)
        {
            var features1 = GetFeatureVector(book1);
            var features2 = GetFeatureVector(book2);

            double dotProduct = features1.Zip(features2, (f1, f2) => f1 * f2).Sum();
            double magnitude1 = Math.Sqrt(features1.Sum(f => f * f));
            double magnitude2 = Math.Sqrt(features2.Sum(f => f * f));
            if (magnitude1 == 0 || magnitude2 == 0)
                return 0;
            return dotProduct / (magnitude1 * magnitude2);
        }

        public double[] GetFeatureVector(Database.Knjige book)
        {
            var featureVector = new List<double>();

            allAuthors = eLibraryContext.Autoris.Select(x=>x.AutorId).ToList();
            allTargetGroups = eLibraryContext.CiljneGrupes.Select(x=>x.CiljnaGrupaId).ToList(); 
            allContentTypes = eLibraryContext.VrsteSadrzajas.Select(x=>x.VrstaSadrzajaId).ToList(); 
            allLanguages = eLibraryContext.Jezicis.Select(x=>x.JezikId).ToList();
            allVrsteGrade = eLibraryContext.VrsteGrades.Select(x=>x.VrstaGradeId).ToList();

            featureVector.AddRange(allAuthors.Select(author => book.KnjigaAutoris.Select(x=>x.AutorId).Contains(author) ? 1.0 : 0.0));
            featureVector.AddRange(allTargetGroups.Select(targetGroup => book.KnjigaCiljneGrupes.Select(x=>x.CiljnaGrupaId).Contains(targetGroup) ? 1.0 : 0.0));
            featureVector.AddRange(allContentTypes.Select(contentType => book.KnjigaVrsteSadrzajas.Select(x=>x.VrstaSadrzajaId).Contains(contentType) ? 1.0 : 0.0));
            featureVector.AddRange(allLanguages.Select(x => x == book.JezikId ? 1.0 : 0.0));
            featureVector.AddRange(allVrsteGrade.Select(x => x == book.VrsteGradeId ? 1.0 : 0.0));

            return featureVector.ToArray();
        }

        private async Task LoadAllData()
        {
            allAuthors = eLibraryContext.Autoris.Select(x => x.AutorId).ToList();
            allTargetGroups = eLibraryContext.CiljneGrupes.Select(x => x.CiljnaGrupaId).ToList();
            allContentTypes = eLibraryContext.VrsteSadrzajas.Select(x => x.VrstaSadrzajaId).ToList();
            allLanguages = eLibraryContext.Jezicis.Select(x => x.JezikId).ToList();
            allVrsteGrade = eLibraryContext.VrsteGrades.Select(x => x.VrstaGradeId).ToList();
        }

        public void TrainData()
        {
            if(mlContext==null) mlContext = new MLContext();
            var allBooksQuery = eLibraryContext
                        .Knjiges
                        .Include(x => x.KnjigaAutoris)
                        .Include(x => x.KnjigaCiljneGrupes)
                        .Include(x => x.KnjigaVrsteSadrzajas);

            var allBooks = allBooksQuery.ToList();

            var data = new List<KnjigaEntry>();

            foreach (var item in allBooks)
            {
                foreach (var rb in allBooks)
                {
                    if (rb.KnjigaId == item.KnjigaId)
                        continue;
                    var similarity = ComputeCosineSimilarity(item, rb);
                    if (similarity > threshold)
                    {
                        data.Add(new KnjigaEntry()
                        {
                            KnjigaId = (uint)item.KnjigaId,
                            CoSimilarKnjigaId = (uint)rb.KnjigaId
                        });
                    }
                }
            }

            var traindata = mlContext.Data.LoadFromEnumerable(data);

            MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
            options.MatrixColumnIndexColumnName = nameof(KnjigaEntry.KnjigaId);
            options.MatrixRowIndexColumnName = nameof(KnjigaEntry.CoSimilarKnjigaId);
            options.LabelColumnName = "Label";
            options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
            options.Alpha = 0.01;
            options.Lambda = 0.005;
            options.NumberOfIterations = 250;
            options.C = 0.00001;

            var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

            model = est.Fit(traindata);

            // Save the trained model to a file
            using (var fs = new FileStream(ModelPath, FileMode.Create, FileAccess.Write, FileShare.Write))
            {
                mlContext.Model.Save(model, traindata.Schema, fs);
            }
        }
    }


    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class KnjigaEntry
    {
        [KeyType(count: 262111)]
        public uint KnjigaId { get; set; }

        [KeyType(count: 262111)]
        public uint CoSimilarKnjigaId { get; set; }

        public float Label { get; set; }
    }


}
