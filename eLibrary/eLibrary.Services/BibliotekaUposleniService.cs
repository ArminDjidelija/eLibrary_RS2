using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eLibrary.Services
{
    public class BibliotekaUposleniService : BaseCRUDServiceAsync<Model.BibliotekaUposleniDTOs.BibliotekaUposleni, BibliotekaUposleniSearchObject, Database.BibliotekaUposleni, BibliotekaUposleniInsertRequest, BibliotekaUposleniUpdateRequest>, IBibliotekaUposleniService
    {
        private readonly ICurrentUserService currentUserService;
        private readonly IKorisniciService korisniciService;

        public BibliotekaUposleniService(ELibraryContext context, IMapper mapper, ICurrentUserService currentUserService, IKorisniciService korisniciService) : base(context, mapper)
        {
            this.currentUserService = currentUserService;
            this.korisniciService = korisniciService;
        }

        public override IQueryable<BibliotekaUposleni> AddFilter(BibliotekaUposleniSearchObject search, IQueryable<BibliotekaUposleni> query)
        {
            //var user = currentUserService.GetUserType();
            //if (user == "Menadzer")
            //{
            //    var bibliotekaId = currentUserService.GetBibliotekaIdFromUser();
            //    query = query.Where(x => x.BibliotekaId == bibliotekaId);
            //}
            if (search?.KorisnikId != null)
            {
                query=query.Where(x=>x.KorisnikId==search.KorisnikId);
            }
            if(search?.BibliotekaId != null)
            {
                query=query.Where(x=>x.BibliotekaId==search.BibliotekaId);
            }
            if (search?.ImePrezimeGTE != null)
            {
                query = query
                   .Include(x => x.Korisnik)
                   .Where(x => (x.Korisnik.Ime + " " + x.Korisnik.Prezime).ToLower().StartsWith(search.ImePrezimeGTE.ToLower()));
            }
            if(search?.EmailGTE != null)
            {
                query=query
                    .Include(x=>x.Korisnik)
                    .Where(x=>x.Korisnik.Email.ToLower().StartsWith(search.EmailGTE.ToLower()));
            }

            query = query
                .Include(x => x.Korisnik)
                .Where(x => x.Korisnik.IsDeleted != true);

            return query;
        }

        public override async Task BeforeInsertAsync(BibliotekaUposleniInsertRequest request, BibliotekaUposleni entity, CancellationToken cancellationToken = default)
        {
            if (request.BibliotekaId == null)
            {
                var user = currentUserService.GetUserType();
                if (user == null)
                {
                    throw new UserException("Greška");
                }
                else if (user.ToLower().Equals("menadzer"))
                {
                    var bibliotekaId = currentUserService.GetBibliotekaIdFromUser();
                    entity.BibliotekaId = bibliotekaId;
                }
            }           
            if (request.DatumUposlenja == null)
            {
                request.DatumUposlenja = DateTime.Now;
            }
        }

        public override async Task AfterDeleteAsync(BibliotekaUposleni entity, CancellationToken cancellationToken)
        {
            await korisniciService.DeleteAsync(entity.KorisnikId, cancellationToken);
            await Context.SaveChangesAsync(cancellationToken);
        }
    }
}
