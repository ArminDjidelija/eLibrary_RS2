using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using eLibrary.Services.RezervacijeStateMachine;
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
        private readonly ICurrentUserService currentUserService;
        public BaseRezervacijeState BaseRezervacijeState { get; set; }

        public RezervacijeService(ELibraryContext context, 
            IMapper mapper, 
            ICurrentUserService currentUserService,
            BaseRezervacijeState baseRezervacijeState) : base(context, mapper)
        {
            this.currentUserService = currentUserService;
            BaseRezervacijeState = baseRezervacijeState;
        }

        public override IQueryable<Rezervacije> AddFilter(RezervacijeSearchObject search, IQueryable<Rezervacije> query)
        {
            //var user = currentUserService.GetUserType();
            //if (user == "Bibliotekar" || user == "Menadzer")
            //{
            //    var bibliotekaId = currentUserService.GetBibliotekaIdFromUser();
            //    query = query
            //        .Include(x=>x.BibliotekaKnjiga)
            //        .Where(x => x.BibliotekaKnjiga.BibliotekaId == bibliotekaId);
            //}

            if(search?.BibliotekaId != null)
            {
                query=query
                    .Include(x=>x.BibliotekaKnjiga)
                    .Where(x=>x.BibliotekaKnjiga.BibliotekaId==search.BibliotekaId);
            }
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

        public override Task<Model.RezervacijeDTOs.Rezervacije> InsertAsync(RezervacijeInsertRequest request, CancellationToken cancellationToken = default)
        {
            var state = BaseRezervacijeState.CreateState("Initial");
            return state.Insert(request);
        }
        public override async Task BeforeInsertAsync(RezervacijeInsertRequest request, Rezervacije entity, CancellationToken cancellationToken = default)
        {
            entity.DatumKreiranja = DateTime.Now;

        }

        public async Task<Model.RezervacijeDTOs.Rezervacije> OdobriAsync(int rezervacijaId, CancellationToken cancellationToken = default)
        {
            var rezervacija = await Context.Rezervacijes.FindAsync(rezervacijaId, cancellationToken);
            if (rezervacija == null)
                throw new UserException("Pogrešan rezervacija id");

            var state = BaseRezervacijeState.CreateState(rezervacija.State);
            return await state.Odobri(rezervacija);
        }

        public async Task<Model.RezervacijeDTOs.Rezervacije> PonistiAsync(int rezervacijaId, CancellationToken cancellationToken = default)
        {
            var rezervacija = await Context.Rezervacijes.FindAsync(rezervacijaId, cancellationToken);
            if (rezervacija == null)
                throw new UserException("Pogrešan rezervacija id");

            var state = BaseRezervacijeState.CreateState(rezervacija.State);
            return await state.Ponisti(rezervacija);
        }

        public async Task<Model.RezervacijeDTOs.Rezervacije> ObnoviAsync(int rezervacijaId, CancellationToken cancellationToken = default)
        {
            var rezervacija = await Context.Rezervacijes.FindAsync(rezervacijaId, cancellationToken);
            if (rezervacija == null)
                throw new UserException("Pogrešan rezervacija id");

            var state = BaseRezervacijeState.CreateState(rezervacija.State);
            return await state.Obnovi(rezervacija);
        }

        public async Task<Model.RezervacijeDTOs.Rezervacije> ZavrsiAsync(int rezervacijaId, CancellationToken cancellationToken = default)
        {
            var rezervacija = await Context.Rezervacijes.FindAsync(rezervacijaId, cancellationToken);
            if (rezervacija == null)
                throw new UserException("Pogrešan rezervacija id");

            var state = BaseRezervacijeState.CreateState(rezervacija.State);
            return await state.Zavrsi(rezervacija);
        }

        public async Task<List<string>> AllowedActions(int rezervacijaId, CancellationToken cancellationToken = default)
        {
            var rezervacija = await Context.Rezervacijes.FindAsync(rezervacijaId, cancellationToken);
            if (rezervacija == null)
                throw new UserException("Pogrešan rezervacija id");

            var state = BaseRezervacijeState.CreateState(rezervacija.State);
            return state.AllowedActions(rezervacija);
        }
    }
}
