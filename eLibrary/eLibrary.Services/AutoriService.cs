using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class AutoriService : BaseCRUDServiceAsync<Model.AutoriDTO.Autori, AutoriSearchObject, Database.Autori, AutoriUpsertRequest, AutoriUpsertRequest>, IAutoriService
    {
        public AutoriService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Autori> AddFilter(AutoriSearchObject search, IQueryable<Database.Autori> query)
        {
            if (!string.IsNullOrEmpty(search?.ImeGTE))
            {
                query=query.Where(x=>x.Ime.ToLower().StartsWith(search.ImeGTE.ToLower()));    
            }
            if (!string.IsNullOrEmpty(search?.PrezimeGTE))
            {
                query = query.Where(x => x.Prezime.ToLower().StartsWith(search.PrezimeGTE.ToLower()));
            }
            if (search?.GodinaRodjenjaGTE != null)
            {
                query = query.Where(x => x.GodinaRodjenja>search.GodinaRodjenjaGTE);
            }
            if (search?.GodinaRodjenjaGTE != null)
            {
                query = query.Where(x => x.GodinaRodjenja < search.GodinaRodjenjaGTE);
            }
            if (string.IsNullOrEmpty(search?.ImeGTE) && string.IsNullOrEmpty(search?.PrezimeGTE) && !string.IsNullOrEmpty(search?.ImePrezimeGTE))
            {
                query = query.Where(x => x.ImePrezime.ToLower().StartsWith(search.ImePrezimeGTE));
            }
            return query;
        }
    }
}
