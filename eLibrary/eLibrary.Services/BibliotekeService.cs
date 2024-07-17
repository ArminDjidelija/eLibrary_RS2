using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore.Diagnostics.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class BibliotekeService : BaseCRUDServiceAsync<Model.BibliotekeDTO.Biblioteke, BibliotekeSearchObject, Database.Biblioteke, BibliotekeUpsertRequest, BibliotekeUpsertRequest>, IBibliotekeService
    {
        public BibliotekeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Biblioteke> AddFilter(BibliotekeSearchObject search, IQueryable<Biblioteke> query)
        {
            if (!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query=query.Where(x=>x.Naziv.ToLower().StartsWith(search.NazivGTE));
            }
            if (!string.IsNullOrEmpty(search?.AdresaGTE))
            {
                query = query.Where(x => x.Adresa.ToLower().StartsWith(search.AdresaGTE));
            }
            if (search?.KantonId!=null)
            {
                query = query.Where(x => x.KantonId==search.KantonId);
            }
            return query;
        }
    }
}
