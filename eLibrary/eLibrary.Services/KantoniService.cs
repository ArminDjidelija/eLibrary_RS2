using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class KantoniService : BaseServiceAsync<Model.KantoniDTO.Kantoni, KantoniSearchObject, Database.Kantoni>, IKantoniService
    {
        public KantoniService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Kantoni> AddFilter(KantoniSearchObject search, IQueryable<Kantoni> query)
        {
            if (!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE));
            }
            return query;
        }
    }
}
