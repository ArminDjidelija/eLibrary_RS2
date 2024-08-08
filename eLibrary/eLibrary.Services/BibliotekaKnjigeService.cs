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
            if (!string.IsNullOrEmpty(search?.Isbn))
            {
                query = query
                    .Include(x => x.Knjiga)
                    .Where(x => x.Knjiga.Isbn == search.Isbn || 
                    (x.Knjiga.Isbn.Replace("-", "")==search.Isbn));
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
    }
}
