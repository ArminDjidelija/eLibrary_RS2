//using eLibrary.Services.Database;
//using MapsterMapper;
//using Microsoft.EntityFrameworkCore;
//using Microsoft.ML;
//using Microsoft.ML.Data;

//namespace eLibrary.Services.Recommender
//{
//    public class fMlRecommenderService : IRecommendService
//    {
//        private readonly IMapper mapper;
//        private readonly ELibraryContext eLibraryContext;
//        private static MLContext mlContext = new MLContext();
//        private static object isLocked = new object();
//        private const string ModelPath = "model.zip";
//        private static ITransformer model = null;

//        public fMlRecommenderService(ELibraryContext eLibraryContext, IMapper mapper)
//        {
//            this.eLibraryContext = eLibraryContext;
//            this.mapper = mapper;
//        }

//        public async Task<List<Model.KnjigeDTOs.Knjige>> GetRecommendedBooks(int citalacId)
//        {
//            if (model == null)
//            {
//                await LoadAllData();

//                lock (isLocked)
//                {
//                    if (File.Exists(ModelPath))
//                    {
//                        using (var stream = new FileStream(ModelPath, FileMode.Open, FileAccess.Read, FileShare.Read))
//                        {
//                            model = mlContext.Model.Load(stream, out var modelInputSchema);
//                        }
//                    }
//                    else
//                    {
//                        TrainData();
//                    }
//                }
//            }

//            var readedBooks = eLibraryContext
//                .CitalacKnjigaLogs
//                .Where(x => x.CitalacId == citalacId)
//                .Select(x => x.KnjigaId)
//                .Distinct()
//                .ToList();

//            var knjiges = eLibraryContext.Knjiges.ToList();
//            var predictionResult = new List<(Database.Knjige, float)>();

//            var predictionEngine = mlContext.Model.CreatePredictionEngine<KnjigaEntry, MoviePrediction>(model);

//            foreach (var knjiga in knjiges)
//            {
//                foreach (var procitanaKnjiga in readedBooks)
//                {
//                    if (procitanaKnjiga == knjiga.KnjigaId)
//                        continue;

//                    var prediction = predictionEngine.Predict(
//                        new KnjigaEntry()
//                        {
//                            KnjigaId = (uint)procitanaKnjiga,
//                            CoSimilarKnjigaId = (uint)knjiga.KnjigaId
//                        });

//                    predictionResult.Add(new(knjiga, prediction.Score));
//                }
//            }

//            var finalResult = predictionResult
//                .OrderByDescending(x => x.Item2)
//                .Select(x => x.Item1)
//                .Distinct()
//                .Where(x => !readedBooks.Any(y => x.KnjigaId == y))
//                .Take(5)
//                .ToList();

//            var knjige = eLibraryContext
//                .Knjiges
//                .Include(x => x.KnjigaAutoris).ThenInclude(x => x.Autor)
//                .Include(x => x.KnjigaVrsteSadrzajas)
//                .Include(x => x.KnjigaCiljneGrupes)
//                .Include(x => x.VrstaGrade)
//                .Include(x => x.Jezik)
//                .Include(x => x.Izdavac)
//                .Include(x => x.Uvez);

//            var lista = new List<Model.KnjigeDTOs.Knjige>();

//            foreach (var k in finalResult)
//            {
//                var knjiga = await knjige.FirstOrDefaultAsync(x => x.KnjigaId == k.KnjigaId);
//                if (knjiga != null)
//                    lista.Add(mapper.Map<Model.KnjigeDTOs.Knjige>(knjiga));
//            }

//            return lista;
//        }

//        private async Task LoadAllData()
//        {
//            // Load all feature data for authors, target groups, content types, languages, etc.
//            allAuthors = eLibraryContext.Autoris.Select(x => x.AutorId).ToList();
//            allTargetGroups = eLibraryContext.CiljneGrupes.Select(x => x.CiljnaGrupaId).ToList();
//            allContentTypes = eLibraryContext.VrsteSadrzajas.Select(x => x.VrstaSadrzajaId).ToList();
//            allLanguages = eLibraryContext.Jezicis.Select(x => x.JezikId).ToList();
//            allVrsteGrade = eLibraryContext.VrsteGrades.Select(x => x.VrstaGradeId).ToList();
//        }

//        public void TrainData()
//        {
//            var allBooksQuery = eLibraryContext
//                .Knjiges
//                .Include(x => x.KnjigaAutoris)
//                .Include(x => x.KnjigaCiljneGrupes)
//                .Include(x => x.KnjigaVrsteSadrzajas);

//            var allBooks = allBooksQuery.ToList();
//            var data = new List<KnjigaEntry>();

//            foreach (var item in allBooks)
//            {
//                foreach (var rb in allBooks)
//                {
//                    if (rb.KnjigaId == item.KnjigaId)
//                        continue;

//                    var similarity = ComputeSimilarity(item, rb);
//                    data.Add(new KnjigaEntry()
//                    {
//                        KnjigaId = (uint)item.KnjigaId,
//                        CoSimilarKnjigaId = (uint)rb.KnjigaId,
//                        Label = (float)similarity
//                    });
//                }
//            }

//            var traindata = mlContext.Data.LoadFromEnumerable(data);

//            var pipeline = _mlContext.Transforms.Text.FeaturizeText(
//                                outputColumnName: "GenresFeaturized",
//                                inputColumnName: nameof(Database.Knjige.VrstaGrade))
//                           .Append(_mlContext.Transforms.Text.FeaturizeText(
//                                outputColumnName: "AuthorsFeaturized",
//                                inputColumnName: nameof(Database.Knjige.KnjigaAutoris)))
//                           .Append(_mlContext.Transforms.Text.FeaturizeText(
//                                outputColumnName: "TitleFeaturized",
//                                inputColumnName: nameof(Database.Knjige.Naziv)))
//                           .Append(_mlContext.Transforms.Concatenate(
//                                outputColumnName: "Features",
//                                "GenresFeaturized",
//                                "AuthorsFeaturized",
//                                "TitleFeaturized"))
//                           .Append(_mlContext.Regression.Trainers.Sdca());

//            var estimator = mlContext.Recommendation().Trainers.MatrixFactorization(options);
//            model = estimator.Fit(traindata);

//            using (var fs = new FileStream(ModelPath, FileMode.Create, FileAccess.Write, FileShare.Write))
//            {
//                mlContext.Model.Save(model, traindata.Schema, fs);
//            }
//        }

//        private double ComputeSimilarity(Database.Knjige book1, Database.Knjige book2)
//        {
//            var features1 = GetFeatureVector(book1);
//            var features2 = GetFeatureVector(book2);

//            return features1.Zip(features2, (f1, f2) => f1 * f2).Sum();
//        }

//        private double[] GetFeatureVector(Database.Knjige book)
//        {
//            var featureVector = new List<double>();

//            featureVector.AddRange(allAuthors.Select(author => book.KnjigaAutoris.Select(x => x.AutorId).Contains(author) ? 1.0 : 0.0));
//            featureVector.AddRange(allTargetGroups.Select(targetGroup => book.KnjigaCiljneGrupes.Select(x => x.CiljnaGrupaId).Contains(targetGroup) ? 1.0 : 0.0));
//            featureVector.AddRange(allContentTypes.Select(contentType => book.KnjigaVrsteSadrzajas.Select(x => x.VrstaSadrzajaId).Contains(contentType) ? 1.0 : 0.0));
//            featureVector.AddRange(allLanguages.Select(x => x == book.JezikId ? 1.0 : 0.0));

//            return featureVector.ToArray();
//        }
//    }

//    public class MoviePrediction
//    {
//        public float Score { get; set; }
//    }

//    public class KnjigaEntry
//    {
//        [KeyType(count: 262111)]
//        public uint KnjigaId { get; set; }

//        [KeyType(count: 262111)]
//        public uint CoSimilarKnjigaId { get; set; }

//        public float Label { get; set; }
//    }
//}
