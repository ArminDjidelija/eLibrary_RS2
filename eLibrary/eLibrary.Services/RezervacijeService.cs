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
    public class RezervacijeService : BaseCRUDServiceAsync<Model.RezervacijeDTOs.Rezervacije, RezervacijeSearchObject, Database.Rezervacije, RezervacijeInsertRequest, RezervacijeUpdateRequest>, IRezervacijeService
    {
        public RezervacijeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Rezervacije> AddFilter(RezervacijeSearchObject search, IQueryable<Rezervacije> query)
        {
            if (search?.Odobreno != null)
            {
                query = query.Where(x => x.Odobreno == search.Odobreno);
            }
            if (search?.Ponistena != null)
            {
                query=query.Where(x=>x.Ponistena==search.Ponistena);
            }
            if(search?.BibliotekaKnjigaId != null)
            {
                query = query.Where(x => x.BibliotekaKnjigaId == search.BibliotekaKnjigaId);
            }
            if(search?.CitalacId != null)
            {
                query=query.Where(x=>x.CitalacId== search.CitalacId);
            }
            if (search?.DatumKreiranjaGTE != null)
            {
                query = query.Where(x => x.DatumKreiranja > search.DatumKreiranjaGTE);
            }
            if (search?.DatumKreiranjaLTE != null)
            {
                query = query.Where(x => x.DatumKreiranja < search.DatumKreiranjaLTE);
            }
            if(search?.RokRezervacijeLTE != null)
            {
                query = query.Where(x => x.RokRezervacije < search.RokRezervacijeLTE);
            }

            return query;
        }

        public override async Task BeforeInsertAsync(RezervacijeInsertRequest request, Rezervacije entity, CancellationToken cancellationToken = default)
        {
            entity.DatumKreiranja = DateTime.Now;

        }
    }
}
