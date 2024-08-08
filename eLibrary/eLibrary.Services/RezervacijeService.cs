using eLibrary.Model.Exceptions;
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
    public class RezervacijeService : BaseCRUDServiceAsync<Model.RezervacijeDTOs.Rezervacije, RezervacijeSearchObject, Database.Rezervacije, RezervacijeInsertRequest, RezervacijeUpdateRequest>, IRezervacijeService
    {
        public RezervacijeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Rezervacije> AddFilter(RezervacijeSearchObject search, IQueryable<Rezervacije> query)
        {
            if (!string.IsNullOrEmpty(search?.ImePrezimeGTE))
            {
                query = query
                    .Include(x => x.Citalac)
                    .Where(x => (x.Citalac.Ime + " " + x.Citalac.Prezime).ToLower().StartsWith(search.ImePrezimeGTE.ToLower()));
            }
            if (!string.IsNullOrEmpty(search?.NaslovGTE))
            {
                query = query
                    .Include(x => x.BibliotekaKnjiga)
                    .ThenInclude(x => x.Knjiga)
                    .Where(x => x.BibliotekaKnjiga.Knjiga.Naslov.ToLower().StartsWith(search.NaslovGTE.ToLower()));
            }
            if (search?.Odobreno != null)
            {
                if (search.Odobreno == false)
                {
                    query = query.Where(x => x.Odobreno == false || x.Odobreno == null);
                }
                else
                {
                    query = query.Where(x => x.Odobreno == true);
                }
            }
            if (search?.Ponistena != null)
            {
                if (search.Ponistena == true)
                {
                    query = query.Where(x => x.Ponistena == true);
                }
                else
                {
                    query=query.Where(x=>x.Ponistena==false || x.Ponistena==null);
                }
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
            if(search?.Aktivna != null)
            {
                if (search.Aktivna == true)
                {
                    query = query
                        .Where(x => (x.RokRezervacije == null || x.RokRezervacije < DateTime.Now) && x.Ponistena != true);
                }
                else
                {
                    query = query
                        .Where(x => (x.RokRezervacije != null || x.RokRezervacije > DateTime.Now) && (x.Ponistena == true || x.Odobreno == false));
                }
            } 

            return query;
        }

        public override async Task BeforeInsertAsync(RezervacijeInsertRequest request, Rezervacije entity, CancellationToken cancellationToken = default)
        {
            entity.DatumKreiranja = DateTime.Now;

        }

        public async Task<Model.RezervacijeDTOs.Rezervacije> OdobriAsync(int rezervacijaId, bool potvrda, CancellationToken cancellationToken = default)
        {
            var rezervacija = await Context.Rezervacijes.FindAsync(rezervacijaId, cancellationToken);
            if (rezervacija == null)
                throw new UserException("Pogrešan rezervacija id");
            //TODO provjera biblioteke i bibliotekara
            rezervacija.Odobreno=potvrda;
            if(potvrda==true)
            {
                rezervacija.RokRezervacije=DateTime.Now.AddDays(1);
            }
            await Context.SaveChangesAsync(cancellationToken);
            return Mapper.Map<Model.RezervacijeDTOs.Rezervacije>(rezervacija);
        }

        public async Task<Model.RezervacijeDTOs.Rezervacije> PonistiAsync(int rezervacijaId, CancellationToken cancellationToken = default)
        {
            var rezervacija = await Context.Rezervacijes.FindAsync(rezervacijaId, cancellationToken);
            if (rezervacija == null)
                throw new UserException("Pogrešan rezervacija id");
            //TODO provjera korisnika
            rezervacija.Ponistena = true;
            await Context.SaveChangesAsync(cancellationToken);
            return Mapper.Map<Model.RezervacijeDTOs.Rezervacije>(rezervacija);
        }
    }
}
