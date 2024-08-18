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
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class BibliotekaKnjigeService : BaseCRUDServiceAsync<Model.BibliotekaKnjigeDTOs.BibliotekaKnjige, BibliotekaKnjigeSearchObject, Database.BibliotekaKnjige, BibliotekaKnjigeInsertRequest, BibliotekaKnjigeUpdateRequest>, IBibliotekaKnjigeService
    {
        private readonly ICurrentUserServiceAsync currentUserService;

        public BibliotekaKnjigeService(ELibraryContext context, IMapper mapper, ICurrentUserServiceAsync currentUserService) : base(context, mapper)
        {
            this.currentUserService = currentUserService;
        }

        public override IQueryable<BibliotekaKnjige> AddFilter(BibliotekaKnjigeSearchObject search, IQueryable<BibliotekaKnjige> query)
        {
            //var user = currentUserService.GetUserType();
            //if(user == "Bibliotekar" || user == "Menadzer")
            //{
            //    var bibliotekaId = currentUserService.GetBibliotekaIdFromUser();
            //    query=query.Where(x=>x.BibliotekaId == bibliotekaId);
            //}
            if (!string.IsNullOrEmpty(search?.Isbn))
            {
                query = query
                    .Include(x => x.Knjiga)
                    .Where(x => x.Knjiga.Isbn.Replace("-", "").StartsWith(search.Isbn.Replace("-", "")));
            }
            if (!string.IsNullOrEmpty(search?.NaslovGTE))
            {
                query = query
                    .Include(x => x.Knjiga)
                    .Where(x => x.Knjiga.Naslov.ToLower().StartsWith(search.NaslovGTE.ToLower()));
            }
            if (!string.IsNullOrEmpty(search?.AutorGTE))
            {
                query = query
                    .Include(x => x.Knjiga)
                    .ThenInclude(x=>x.KnjigaAutoris)
                    .ThenInclude(x=>x.Autor)
                    .Where(x => x
                    .Knjiga.KnjigaAutoris
                    .Any(x=>(x.Autor.Ime+" "+x.Autor.Prezime).ToLower().StartsWith(search.AutorGTE.ToLower())));
            }
            if (search?.BibliotekaId != null)
            {
                query=query.Where(x=>x.BibliotekaId==search.BibliotekaId);
            }
            if(search?.KnjigaId != null)
            {
                query=query.Where(x=>x.KnjigaId==search.KnjigaId);
            }
            if (search?.BrojKopijaGTE != null)
            {
                query = query.Where(x => x.BrojKopija > search.BrojKopijaGTE);
            }
            if(search?.DatumDodavanjaGTE != null)
            {
                query = query.Where(x => x.DatumDodavanja > search.DatumDodavanjaGTE);
            }
            if (search?.DatumDodavanjaLTE != null)
            {
                query = query.Where(x => x.DatumDodavanja < search.DatumDodavanjaLTE);
            }
            return query;
        }

        public override async Task BeforeInsertAsync(BibliotekaKnjigeInsertRequest request, BibliotekaKnjige entity, CancellationToken cancellationToken = default)
        {
            var bk = await Context
                .BibliotekaKnjiges
                .Where(x => x.KnjigaId == request.KnjigaId && x.BibliotekaId == request.BibliotekaId)
                .FirstOrDefaultAsync(cancellationToken);
            if (bk != null)
                throw new UserException("Vec imate ovu knjigu u fondovima biblioteke");

            var bibliotekaId = await currentUserService.GetBibliotekaIdFromUserAsync();
            entity.BibliotekaId = bibliotekaId;
        }

        public override async Task CustomMapPagedResponseAsync(List<Model.BibliotekaKnjigeDTOs.BibliotekaKnjige> result, CancellationToken cancellationToken = default)
        {
            foreach (var item in result)
            {
                var ukupnoPozajmljeno = await Context
                    .Pozajmices
                    .Where(x => x.BibliotekaKnjigaId == item.BibliotekaKnjigaId && x.StvarniDatumVracanja == null)
                    .CountAsync(cancellationToken);
                item.TrenutnoDostupno = item.DostupnoPozajmica-ukupnoPozajmljeno;
            }
        }

        public async Task<List<Model.BibliotekaKnjigeDTOs.PozajmicaInfo>> GenerateReportData(int bibliotekaKnjigaId, CancellationToken cancellationToken = default)
        {
            var result = new List<Model.BibliotekaKnjigeDTOs.PozajmicaInfo>();

            DateTime danasnjiDatum = DateTime.Now;
            DateTime pocetniDatum = danasnjiDatum.AddMonths(-11).AddDays(1 - danasnjiDatum.Day);

            var pozajmicePosljednjih12Mjeseci = await Context
                .Pozajmices
                .Where(x => x.BibliotekaKnjigaId == bibliotekaKnjigaId && x.DatumPreuzimanja >= pocetniDatum)
                .GroupBy(p => new { p.DatumPreuzimanja.Year, p.DatumPreuzimanja.Month })
                .Select(g => new
                {
                    Mjesec = new DateTime(g.Key.Year, g.Key.Month, 1),
                    BrojPozajmica = g.Count()
                })
                .ToListAsync(cancellationToken);

            for(int i = 0; i < 12; i++)
            {
                var trenutniMjesec = pocetniDatum.AddMonths(i);
                var pozajmiceZaMjesec = pozajmicePosljednjih12Mjeseci
                    .FirstOrDefault(p => p.Mjesec.Year == trenutniMjesec.Year && p.Mjesec.Month == trenutniMjesec.Month);

                result.Add(new Model.BibliotekaKnjigeDTOs.PozajmicaInfo
                {
                    Rb = i +1,
                    MjesecString = trenutniMjesec.ToString("MMM", new CultureInfo("bs-Latn-BA")),
                    BrojPozajmica = pozajmiceZaMjesec?.BrojPozajmica ?? 0,
                    MjesecInt = trenutniMjesec.Month,
                });
            }

            return result;
        }
    }
}
