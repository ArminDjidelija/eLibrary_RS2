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
        //private readonly MLContext mlContext;
        private readonly IMapper mapper;

        private readonly ELibraryContext eLibraryContext;

        public MlRecommenderService(ELibraryContext eLibraryContext, IMapper mapper)
        {
            this.eLibraryContext = eLibraryContext;
            this.mapper = mapper;
        }
        float threshold = 0.75f;
        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;
        public Task<List<Model.KnjigeDTOs.Knjige>> GetRecommendedBooks(int citalacId)
        {
            
            if (mlContext == null)
            {

                //train
                lock (isLocked)
                {
                    mlContext = new MLContext();

                    var allBooksQuery = eLibraryContext
                        .Knjiges
                        .Include(x => x.KnjigaAutoris)
                        .Include(x => x.KnjigaCiljneGrupes)
                        .Include(x => x.KnjigaVrsteSadrzajas);

                    var allBooks = allBooksQuery.ToList();

                    var data = new List<KnjigaEntry>();

                    foreach (var item in allBooks)
                    {
                        //if (item.NarudzbaStavkes.Count > 1)
                        //{
                        //    var distinctItemId = item.NarudzbaStavkes.Select(y => y.ProizvodId).Distinct().ToList();

                        //    distinctItemId.ForEach(y =>
                        //    {
                        //        var relatedItems = item.NarudzbaStavkes.Where(z => z.ProizvodId != y);

                        //        foreach (var z in relatedItems)
                        //        {
                        //            data.Add(new ProductEntry()
                        //            {
                        //                ProductID = (uint)y,
                        //                CoPurchaseProductID = (uint)z.ProizvodId
                        //            });
                        //        }
                        //    });
                        //}

                        //var authorIds = item.KnjigaAutoris.Select(y => y.AutorId).ToList();
                        //var targetGroupIds = item.KnjigaCiljneGrupes.Select(y => y.CiljnaGrupaId).ToList();
                        //var contentTypeIds = item.KnjigaVrsteSadrzajas.Select(y => y.VrstaSadrzajaId).ToList();

                        //var relatedBooks = allBooksQuery
                        //  .Where(x => x.KnjigaAutoris.Any(x1 => authorIds.Contains(x1.AutorId)) ||
                        //              x.KnjigaCiljneGrupes.Any(x1 => targetGroupIds.Contains(x1.CiljnaGrupaId)) ||
                        //              x.KnjigaVrsteSadrzajas.Any(x1 => contentTypeIds.Contains(x1.VrstaSadrzajaId))
                        //    ).ToList();

                        foreach(var rb in allBooks)
                        {
                            if (rb.KnjigaId == item.KnjigaId)
                                continue;
                            var similarity = ComputeCosineSimilarity(item, rb);
                            if(similarity > threshold)
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
                    options.Lambda = 0.025;
                    // For better results use the following parameters
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(traindata);
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

            var finalResult = predictionResult
                .OrderByDescending(x => x.Item2)
                .Select(x => x.Item1)
                .Distinct()
                .Where(x=> !readedBooks.Any(y=>x.KnjigaId==y))
                .Take(5)
                .ToList();

            var list = 1;
            return null;

            //return Mapper.Map<List<Model.KnjigeDTOs.Knjige>>(finalResult);
        }

        public double ComputeCosineSimilarity(Database.Knjige book1, Database.Knjige book2)
        {
            var features1 = GetFeatureVector(book1);
            var features2 = GetFeatureVector(book2);

            double dotProduct = features1.Zip(features2, (f1, f2) => f1 * f2).Sum();
            double magnitude1 = Math.Sqrt(features1.Sum(f => f * f));
            double magnitude2 = Math.Sqrt(features2.Sum(f => f * f));

            return dotProduct / (magnitude1 * magnitude2);
        }

        public double[] GetFeatureVector(Database.Knjige book)
        {
            var featureVector = new List<double>();

            // Define the feature space based on the maximum number of unique attributes
            var allAuthors = eLibraryContext.Autoris.Select(x=>x.AutorId).ToList(); // List all unique authors
            var allTargetGroups = eLibraryContext.CiljneGrupes.Select(x=>x.CiljnaGrupaId).ToList(); // List all unique target groups
            var allContentTypes = eLibraryContext.VrsteSadrzajas.Select(x=>x.VrstaSadrzajaId).ToList(); // List all unique content types

            featureVector.AddRange(allAuthors.Select(author => book.KnjigaAutoris.Select(x=>x.AutorId).Contains(author) ? 1.0 : 0.0));
            featureVector.AddRange(allTargetGroups.Select(targetGroup => book.KnjigaCiljneGrupes.Select(x=>x.CiljnaGrupaId).Contains(targetGroup) ? 1.0 : 0.0));
            featureVector.AddRange(allContentTypes.Select(contentType => book.KnjigaVrsteSadrzajas.Select(x=>x.VrstaSadrzajaId).Contains(contentType) ? 1.0 : 0.0));

            return featureVector.ToArray();
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
