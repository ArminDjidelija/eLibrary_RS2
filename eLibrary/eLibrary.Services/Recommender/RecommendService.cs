using eLibrary.Model.KnjigeDTOs;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.Recommender
{
    public class RecommendService : IRecommendService
    {
        public RecommendService(ELibraryContext context, IMapper mapper)
        {
            this.context = context;
            this.mapper = mapper;
        }
        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;
        private readonly ELibraryContext context;
        private readonly IMapper mapper;

        public async Task<List<Model.KnjigeDTOs.Knjige>> GetRecommendedBooks(int citalacId)
        {
            var userLikedBooks = await context.CitalacKnjigaLogs.Where(x => x.CitalacId == citalacId).Select(x => x.KnjigaId).Distinct().ToListAsync();
            var allBooks = await context
                .Knjiges
                .Include(x => x.KnjigaAutoris)
                .Include(x => x.KnjigaCiljneGrupes)
                .Include(x => x.KnjigaVrsteSadrzajas)
                .Include(x => x.Jezik).ToListAsync();

            var recommendedBooks = RecommendBooks(new CitalacKnjiga { CitalacId = citalacId, KnjigeIds = userLikedBooks }, allBooks);

            return mapper.Map<List<Model.KnjigeDTOs.Knjige>> (recommendedBooks);
        }

        public float[] CreateFeatureVector(Database.Knjige knjiga)
        {
            var vector = new List<float>();

            var allAuthors = context.Autoris;
            var allVrsteSadrzaja = context.VrsteSadrzajas;
            var allCiljneGrupe = context.CiljneGrupes;
            var allJezici = context.Jezicis;
            foreach ( var author in allAuthors )
            {
                vector.Add(knjiga.KnjigaAutoris.Select(x => x.AutorId).Contains(author.AutorId) ? 1.0f : 0.0f);
            }

            foreach (var vrsta in allVrsteSadrzaja)
            {
                vector.Add(knjiga.KnjigaVrsteSadrzajas.Select(x => x.VrstaSadrzajaId).Contains(vrsta.VrstaSadrzajaId) ? 1.0f : 0.0f);
            }

            foreach (var ciljna in allCiljneGrupe)
            {
                vector.Add(knjiga.KnjigaCiljneGrupes.Select(x => x.CiljnaGrupaId).Contains(ciljna.CiljnaGrupaId) ? 1.0f : 0.0f);
            }

            foreach(var jezik in allJezici)
            {
                vector.Add(knjiga.JezikId==jezik.JezikId ? 1.0f : 0.0f);
            }

            return vector.ToArray();
        }

        public float ComputeCosineSimilarity(float[] vectorA, float[] vectorB)
        {
            float dotProduct = 0;
            float normA = 0;
            float normB = 0;
            for (int i = 0; i < vectorA.Length; i++)
            {
                dotProduct += vectorA[i] * vectorB[i];
                normA += vectorA[i] * vectorA[i];
                normB += vectorB[i] * vectorB[i];
            }
            return dotProduct / (MathF.Sqrt(normA) * MathF.Sqrt(normB));
        }

        public List<Database.Knjige> RecommendBooks(CitalacKnjiga userLikedBooks, List<Database.Knjige> allBooks)
        {
            var likedBookVectors = userLikedBooks.KnjigeIds
                .Select(id => CreateFeatureVector(allBooks.First(b => b.KnjigaId == id)))
                .ToList();

            var recommendedBooks = new List<Tuple<Database.Knjige, float>>();

            foreach (var book in allBooks)
            {
                if (userLikedBooks.KnjigeIds.Contains(book.KnjigaId))
                    continue;

                var bookVector = CreateFeatureVector(book);
                float maxSimilarity = likedBookVectors.Max(v => ComputeCosineSimilarity(v, bookVector));

                recommendedBooks.Add(new Tuple<Database.Knjige, float>(book, maxSimilarity));
            }

            return recommendedBooks
                .OrderByDescending(x => x.Item2)
                .Select(x => x.Item1)
                .Distinct()
                .Take(10)
                .ToList();
        }
    }

    public class CitalacKnjiga
    {
        public int CitalacId { get; set; }
        public List<int> KnjigeIds { get; set; }
    }

    public class BookFeature
    {
        public int KnjigaId { get; set; }
        public float[] Features { get; set; }
    }

}
