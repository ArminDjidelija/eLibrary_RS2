using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
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
    public class PozajmiceService : BaseCRUDServiceAsync<Model.PozajmiceDTOs.Pozajmice, PozajmiceSearchObject, Database.Pozajmice, PozajmiceInsertRequest, PozajmiceUpdateRequest>, IPozajmiceService
    {
        private readonly IObavijestiService _obavijestiService;

        public PozajmiceService(ELibraryContext context, IMapper mapper, IObavijestiService obavijestiService) : base(context, mapper)
        {
            _obavijestiService = obavijestiService;
        }

        public override IQueryable<Pozajmice> AddFilter(PozajmiceSearchObject search, IQueryable<Pozajmice> query)
        {

            if(search?.BibliotekaId != null)
            {
                query = query
                    .Include(x => x.BibliotekaKnjiga)
                    .Where(x => x.BibliotekaKnjiga.BibliotekaId == search.BibliotekaId);
            }
            if (search?.Vraceno != null)
            {
                if (search.Vraceno == true)
                {
                    query = query.Where(x => x.StvarniDatumVracanja.HasValue);
                }
                else
                {
                    query = query.Where(x => x.StvarniDatumVracanja == null);
                }
            }
            if (search?.CitalacId != null)
            {
                query=query.Where(x=>x.CitalacId==search.CitalacId);
            }
            if (search?.BibliotekaKnjigaId != null)
            {
                query = query.Where(x => x.BibliotekaKnjigaId == search.BibliotekaKnjigaId);
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
            return query;
        }

        public override async Task BeforeInsertAsync(PozajmiceInsertRequest request, Pozajmice entity, CancellationToken cancellationToken = default)
        {
            if (request.Trajanje <= 0)
            {
                throw new UserException("Trajanje mora biti minimalno 1 dan!");
            }
            if (request.Trajanje > 365)
            {
                throw new UserException("Pozajmica ne može biti veća od jedne godine dana!");
            }
            entity.DatumPreuzimanja=DateTime.Now;
            entity.PreporuceniDatumVracanja = DateTime.Now.AddDays(request.Trajanje);
        }

        public async Task<Model.PozajmiceDTOs.Pozajmice> PotvrdiVracanje(int pozajmicaId, CancellationToken cancellationToken = default)
        {
            var pozajmica = await Context.Pozajmices.FindAsync(pozajmicaId, cancellationToken);
            if (pozajmica == null)
                throw new UserException("Pogrešan ID pozajmice!");
            
            pozajmica.StvarniDatumVracanja=DateTime.Now;
            await Context.SaveChangesAsync(cancellationToken);
            return Mapper.Map<Model.PozajmiceDTOs.Pozajmice>(pozajmica);
        }

        public async Task ObavijestiORoku(int pozajmicaId, CancellationToken cancellationToken = default)
        {
            var naslov = "Obavijest o roku";
            var pozajmica = await Context.Pozajmices.Include(x=>x.BibliotekaKnjiga.Knjiga).Include(x=>x.BibliotekaKnjiga.Biblioteka).FirstOrDefaultAsync(x=> x.PozajmicaId ==  pozajmicaId);
            if (pozajmica == null)
                throw new UserException("Pogrešna pozajmica!");
            var tekst = $"Poštovani,\n" +
                $"Vaša pozajmica knjige {pozajmica.BibliotekaKnjiga.Knjiga.Naslov} u biblioteci {pozajmica.BibliotekaKnjiga.Biblioteka.Naziv} ističe " +
                $"{pozajmica.PreporuceniDatumVracanja.ToString("dd.MM.yyyy HH:mm")}." +
                $"\nSrdačan pozdrav";

            var obavijest = new ObavijestiInsertRequest
            {
                BibliotekaId = pozajmica.BibliotekaKnjiga.BibliotekaId,
                CitalacId = pozajmica.CitalacId,
                Naslov = naslov,
                Tekst = tekst
            };
            await _obavijestiService.InsertAsync(obavijest);
        }
    }
}
