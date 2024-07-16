using eLibrary.Model;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace eLibrary.Services
{
    public class JeziciService : BaseCRUDService<Model.Jezici, JeziciSearchObject, Database.Jezici, JeziciUpsertRequest, JeziciUpsertRequest>, IJeziciService
    {
        public JeziciService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Jezici> AddFilter(JeziciSearchObject search, IQueryable<Database.Jezici> query)
        {
            if (!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query = query
                    .Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }
            return query;
        }
    }
}
