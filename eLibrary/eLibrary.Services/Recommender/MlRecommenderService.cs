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
            mlContext = new MLContext();

        }

        static MLContext mlContext = null;
        static object isLocked = new object();
        const string ModelPath = "model.zip";
        static ITransformer model = null;
        public async Task<List<Model.KnjigeDTOs.Knjige>> GetRecommendedBooks(int citalacId)
        {
            try
            {
                var allBooksQuery = eLibraryContext
                .Knjiges
                .Include(x => x.KnjigaAutoris).ThenInclude(x => x.Autor)
                .Include(x => x.KnjigaCiljneGrupes).ThenInclude(x => x.CiljnaGrupa)
                .Include(x => x.VrstaGrade)
                .Include(x => x.KnjigaVrsteSadrzajas).ThenInclude(x => x.VrstaSadrzaja)
                .Include(x => x.Jezik)
                .AsQueryable();

                var readedBookIds = eLibraryContext
                    .CitalacKnjigaLogs
                    .Where(x => x.CitalacId == citalacId)
                    .Select(x => x.KnjigaId)
                    .Distinct()
                    .ToList();

                var readedBooks = await allBooksQuery
                    .Where(x => readedBookIds.Contains(x.KnjigaId))
                    .ToListAsync();

                var readedBookData = readedBooks.Select(k => new KnjigaData
                {
                    KnjigaId = k.KnjigaId,
                    Autori = string.Join(", ", k.KnjigaAutoris.Select(ka => ka.Autor.Ime + " " + ka.Autor.Prezime)),
                    CiljneGrupe = string.Join(", ", k.KnjigaCiljneGrupes.Select(kcg => kcg.CiljnaGrupa.Naziv)),
                    VrsteGrade = k.VrstaGrade.Naziv
                }).ToList();

                var allBookData = allBooksQuery
                    .Select(k => new
                    {
                        k.KnjigaId,
                        Autori = k.KnjigaAutoris.Select(ka => ka.Autor.Ime + " " + ka.Autor.Prezime).OrderBy(x => x).ToList(),
                        CiljneGrupe = k.KnjigaCiljneGrupes.Select(kcg => kcg.CiljnaGrupa.Naziv).OrderBy(x => x).ToList(),
                        VrsteGrade = k.VrstaGrade.Naziv,
                        VrsteSadrzaja = k.KnjigaVrsteSadrzajas.Select(kcg => kcg.VrstaSadrzaja.Naziv).OrderBy(x => x).ToList(),
                        Jezik = k.Jezik.Naziv,
                        k.Naslov
                    })
                    .AsEnumerable()
                    .Select(k => new KnjigaData
                    {
                        KnjigaId = k.KnjigaId,
                        Autori = string.Join(", ", k.Autori),
                        CiljneGrupe = string.Join(", ", k.CiljneGrupe),
                        VrsteGrade = k.VrsteGrade,
                        VrsteSadrzaja = string.Join(", ", k.VrsteSadrzaja),
                        Jezik = k.Jezik,
                        Naslov = k.Naslov
                    })
                    .ToList();

                var pipeline = mlContext.Transforms.Text.FeaturizeText("AutoriFeaturized", nameof(KnjigaData.Autori))
                               .Append(mlContext.Transforms.Text.FeaturizeText("CiljneGrupeFeaturized", nameof(KnjigaData.CiljneGrupe)))
                               .Append(mlContext.Transforms.Text.FeaturizeText("VrsteGradeFeaturized", nameof(KnjigaData.VrsteGrade)))
                               .Append(mlContext.Transforms.Text.FeaturizeText("VrsteSadrzajaFeaturized", nameof(KnjigaData.VrsteSadrzaja)))
                               .Append(mlContext.Transforms.Text.FeaturizeText("JezikFeaturized", nameof(KnjigaData.Jezik)))
                               .Append(mlContext.Transforms.Text.FeaturizeText("NaslovFeaturized", nameof(KnjigaData.Naslov)))
                               .Append(mlContext.Transforms.Concatenate("Features",
                                    "AutoriFeaturized",
                                    "CiljneGrupeFeaturized",
                                    "VrsteGradeFeaturized",
                                    "VrsteSadrzajaFeaturized",
                                    "JezikFeaturized"));

                var model = pipeline.Fit(mlContext.Data.LoadFromEnumerable(allBookData));

                var predictions = new List<KnjigaPrediction>();
                var predictionEngine = mlContext.Model.CreatePredictionEngine<KnjigaData, KnjigaPrediction>(model);
                Console.WriteLine("SVE OK 1 ----------------------------");

                foreach (var book in allBookData)
                {
                    if (readedBookData.Any(rb => rb.KnjigaId == book.KnjigaId))
                        continue;

                    var bookVector = predictionEngine.Predict(book).Features;

                    float totalScore = 0;
                    foreach (var readedBook in readedBookData)
                    {
                        var readedVector = predictionEngine.Predict(readedBook).Features;
                        totalScore += CalculateCosineSimilarity(bookVector, readedVector);
                    }

                    predictions.Add(new KnjigaPrediction
                    {
                        Id = book.KnjigaId,
                        Score = totalScore / readedBookData.Count
                    });
                }
                Console.WriteLine("SVE OK 2 ----------------------------");

                var predictionIds = predictions.OrderByDescending(x => x.Score).Take(5).Select(x => x.Id).ToList();
                Console.WriteLine("SVE OK 3 ----------------------------");
                var data = await allBooksQuery.Where(x => predictionIds.Contains(x.KnjigaId)).ToListAsync();

                return mapper.Map<List<Model.KnjigeDTOs.Knjige>>(data);
            }
            catch (Exception ex)
            {
                throw ex.InnerException;
            }
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

            allAuthors = eLibraryContext.Autoris.Select(x => x.AutorId).ToList();
            allTargetGroups = eLibraryContext.CiljneGrupes.Select(x => x.CiljnaGrupaId).ToList();
            allContentTypes = eLibraryContext.VrsteSadrzajas.Select(x => x.VrstaSadrzajaId).ToList();
            allLanguages = eLibraryContext.Jezicis.Select(x => x.JezikId).ToList();
            //allVrsteGrade = eLibraryContext.VrsteGrades.Select(x=>x.VrstaGradeId).ToList();

            featureVector.AddRange(allAuthors.Select(author => book.KnjigaAutoris.Select(x => x.AutorId).Contains(author) ? 1.0 : 0.0));
            featureVector.AddRange(allTargetGroups.Select(targetGroup => book.KnjigaCiljneGrupes.Select(x => x.CiljnaGrupaId).Contains(targetGroup) ? 1.0 : 0.0));
            featureVector.AddRange(allContentTypes.Select(contentType => book.KnjigaVrsteSadrzajas.Select(x => x.VrstaSadrzajaId).Contains(contentType) ? 1.0 : 0.0));
            featureVector.AddRange(allLanguages.Select(x => x == book.JezikId ? 1.0 : 0.0));
            //featureVector.AddRange(allVrsteGrade.Select(x => x == book.VrsteGradeId ? 1.0 : 0.0));

            return featureVector.ToArray();
        }

        public void TrainData()
        {
            if (mlContext == null) mlContext = new MLContext();
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
                    data.Add(new KnjigaEntry()
                    {
                        KnjigaId = (uint)item.KnjigaId,
                        CoSimilarKnjigaId = (uint)rb.KnjigaId,
                        Label = (float)similarity
                    });

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
            options.NumberOfIterations = 100;
            options.C = 0.00001;
            var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

            model = est.Fit(traindata);

            // save model to file
            using (var fs = new FileStream(ModelPath, FileMode.Create, FileAccess.Write, FileShare.Write))
            {
                mlContext.Model.Save(model, traindata.Schema, fs);
            }
        }

        private float CalculateCosineSimilarity(float[] vectorA, float[] vectorB)
        {
            float dotProduct = 0;
            float magnitudeA = 0;
            float magnitudeB = 0;

            for (int i = 0; i < vectorA.Length; i++)
            {
                dotProduct += vectorA[i] * vectorB[i];
                magnitudeA += vectorA[i] * vectorA[i];
                magnitudeB += vectorB[i] * vectorB[i];
            }

            magnitudeA = MathF.Sqrt(magnitudeA);
            magnitudeB = MathF.Sqrt(magnitudeB);

            return dotProduct / (magnitudeA * magnitudeB);
        }
    }

    public class KnjigaEntry
    {
        [KeyType(count: 262111)]
        public uint KnjigaId { get; set; }

        [KeyType(count: 262111)]
        public uint CoSimilarKnjigaId { get; set; }

        public float Label { get; set; }
    }

    public class KnjigaData
    {
        public int KnjigaId { get; set; }
        public string Autori { get; set; }
        public string CiljneGrupe { get; set; }
        public string VrsteGrade { get; set; }
        public string VrsteSadrzaja { get; set; }
        public string Jezik { get; set; }
        public string Naslov { get; set; }
    }

    public class KnjigaPrediction
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public float Score { get; set; }
        [VectorType]
        public float[] Features { get; set; }
    }
}
