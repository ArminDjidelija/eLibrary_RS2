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
    public class UlogeService : BaseServiceAsync<Model.UlogeDTOs.Uloge, UlogeSearchObject, Database.Uloge>, IUlogeService
    {
        public UlogeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Uloge> AddFilter(UlogeSearchObject search, IQueryable<Uloge> query)
        {
            if(!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }
            return query;
        }

        public Uloge? GetByNaziv(string naziv)
        {
            var uloga = Context.Uloges.FirstOrDefault(x=>x.Naziv.ToLower()==naziv.ToLower());
            return uloga;
        }
    }
}
