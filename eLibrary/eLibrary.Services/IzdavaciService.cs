using eLibrary.Model.Requests;
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
    public class IzdavaciService : BaseCRUDServiceAsync<Model.IzdavaciDTOs.Izdavaci, IzdavaciSearchObject, Database.Izdavaci, IzdavaciUpsertRequest, IzdavaciUpsertRequest>, IIzdavaciService
    {
        public IzdavaciService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Izdavaci> AddFilter(IzdavaciSearchObject search, IQueryable<Izdavaci> query)
        {
            if (!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE));
            }
            return query;
        }
    }
}
