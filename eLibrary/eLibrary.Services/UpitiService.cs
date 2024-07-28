using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class UpitiService : BaseCRUDServiceAsync<Model.UpitiDTO.Upiti, UpitiSearchObject, Database.Upiti, UpitiInsertRequest, UpitiUpdateRequest>, IUpitiService
    {
        public UpitiService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Upiti> AddFilter(UpitiSearchObject search, IQueryable<Upiti> query)
        {
            if(!string.IsNullOrEmpty(search?.ImeGTE) || 
                !string.IsNullOrEmpty(search?.PrezimeGTE) ||
                !string.IsNullOrEmpty(search?.ImePrezimeGTE))
            {
                query = query.Include(x => x.Citalac);

                if (!string.IsNullOrEmpty(search?.ImeGTE))
                {
                    query = query.Where(x => x.Citalac.Ime.ToLower().StartsWith(search.ImeGTE));
                }
                if (!string.IsNullOrEmpty(search?.ImeGTE))
                {
                    query = query.Where(x => x.Citalac.Prezime.ToLower().StartsWith(search.PrezimeGTE));
                }
                if (!string.IsNullOrEmpty(search?.ImeGTE))
                {
                    query = query.Where(x => x.Citalac.Prezime.ToLower().StartsWith(search.PrezimeGTE));
                }
                if (!string.IsNullOrEmpty(search?.ImePrezimeGTE) &&
                (string.IsNullOrEmpty(search?.ImeGTE) && string.IsNullOrEmpty(search?.PrezimeGTE)))
                {
                    query = query.Where(x => (x.Citalac.Ime+" "+x.Citalac.Prezime).ToLower().StartsWith(search.ImePrezimeGTE.ToLower()));
                }
            }

            if (search?.CitalacId!=null)
            {
                query=query.Where(x=>x.CitalacId==search.CitalacId);
            }
            if (search?.Odgovoreno != null)
            {
                if (search.Odgovoreno==true)
                {
                    query = query.Where(x => x.Odgovor != null);
                }
                else
                {
                    query = query.Where(x => x.Odgovor == null);
                }
            }
            return query;
        }
    }
}
