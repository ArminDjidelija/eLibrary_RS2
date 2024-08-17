using eLibrary.Model.Exceptions;
using eLibrary.Model.Messages;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using eLibrary.Services.RabbitMqService;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System.Security.Cryptography;
using System.Text;

namespace eLibrary.Services
{
    public class KorisniciService : BaseCRUDServiceAsync<Model.KorisniciDTOs.Korisnici, KorisniciSearchObject, Database.Korisnici, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        private readonly ILogger<KorisniciService> _logger;
        private readonly IPasswordService _passwordService;
        private readonly ICurrentUserServiceAsync currentUserService;
        private readonly IUlogeService ulogeService;
        private readonly IRabbitMqService rabbitMqService;

        public KorisniciService(ELibraryContext context, 
            IMapper mapper, 
            ILogger<KorisniciService> logger,
            IPasswordService passwordService,
            ICurrentUserServiceAsync currentUserService,
            IUlogeService ulogeService,
            IRabbitMqService rabbitMqService) : base(context, mapper)
        {
            _logger = logger;
            _passwordService = passwordService;
            this.currentUserService = currentUserService;
            this.ulogeService = ulogeService;
            this.rabbitMqService = rabbitMqService;
        }

        public override IQueryable<Korisnici> AddFilter(KorisniciSearchObject search, IQueryable<Korisnici> query)
        {
           
            if (!string.IsNullOrEmpty(search?.ImeGTE))
            {
                query = query.Where(x => x.Ime.ToLower().StartsWith(search.ImeGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.PrezimeGTE))
            {
                query = query.Where(x => x.Prezime.ToLower().StartsWith(search.PrezimeGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.ImePrezimeGTE) &&
                (string.IsNullOrEmpty(search?.ImeGTE) && string.IsNullOrEmpty(search?.PrezimeGTE)))
            {
                query = query.Where(x => (x.Ime+" "+x.Prezime).ToLower().StartsWith(search.ImePrezimeGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.Telefon))
            {
                query = query.Where(x => x.Telefon==search.Telefon);
            }

            if (!string.IsNullOrEmpty(search?.EmailGTE))
            {
                query = query.Where(x => x.Email.ToLower().StartsWith(search.EmailGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.KorisnickoIme))
            {
                query = query.Where(x => x.KorisnickoIme == search.KorisnickoIme);
            }

            if(search.Status != null)
            {
                query=query.Where(x=>x.Status==search.Status);
            }

            return query;
        }

        
        public override async Task BeforeInsertAsync(KorisniciInsertRequest request, Korisnici entity, CancellationToken cancellationToken=default)
        {
            _logger.LogInformation($"Adding user: {entity.KorisnickoIme}");

            if (string.IsNullOrEmpty(request.Lozinka) || string.IsNullOrEmpty(request.LozinkaPotvrda))
                throw new UserException("Lozinka i potvrda lozinke moraju imati vrijednost");

            if (request.Lozinka != request.LozinkaPotvrda)
                throw new UserException("Lozinka i potvrda lozinke moraju biti iste");

            var user = await Context.Korisnicis.FirstOrDefaultAsync(x => x.KorisnickoIme == request.KorisnickoIme);
            if (user != null)
                throw new UserException("Korisnik sa ovim korisničkim imenom već postoji!");
            
            entity.LozinkaSalt = _passwordService.GenerateSalt();
            entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);


        }

        public override async Task AfterInsertAsync(KorisniciInsertRequest request, Korisnici entity, CancellationToken cancellationToken = default)
        {
            if (request.Uloge != null && request.Uloge.Count>0)
            {
                foreach (var u in request.Uloge)
                {
                    Context.KorisniciUloges.Add(new Database.KorisniciUloge
                    {
                        KorisnikId = entity.KorisnikId,
                        UlogaId = u
                    });
                }
                await Context.SaveChangesAsync(cancellationToken);
            }
          
        }

        public override async Task BeforeUpdateAsync(KorisniciUpdateRequest request, Korisnici entity, CancellationToken cancellationToken = default)
        {
            
            if(request.Lozinka!=null && request.LozinkaPotvrda != null)
            {
                if (request.StaraLozinka == null)
                    throw new UserException("Morate poslati staru lozinku!");
                var lozinkaCheck = _passwordService.GenerateHash(entity.LozinkaSalt, request.StaraLozinka) == entity.LozinkaHash;
                if (lozinkaCheck == false)
                    throw new UserException("Pogrešna stara lozinka");
                if (request.Lozinka == request.LozinkaPotvrda)
                {
                    entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);
                }
            }
        }

        public override async Task<Model.KorisniciDTOs.Korisnici> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            //await rabbitMqService.SendAnEmail(new EmailDTO
            //{
            //    EmailTo = "didelija.armin@gmail.com",
            //    Message = DateTime.Now.ToString(),
            //    ReceiverName = "Armin",
            //    Subject = "Naslov"
            //});

            return await base.GetByIdAsync(id, cancellationToken);
        }


        public Model.KorisniciDTOs.Korisnici Login(string username, string password)
        {
            var entity = Context
                .Korisnicis
                .Include(x => x.KorisniciUloges)
                    .ThenInclude(y => y.Uloga).FirstOrDefault(x => x.KorisnickoIme == username);

            if(entity==null)
            {
                return null; 
            }

            var hash = _passwordService.GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }
            var mapped = this.Mapper.Map<Model.KorisniciDTOs.Korisnici>(entity);
            
            var biblioteka = Context.BibliotekaUposlenis.FirstOrDefault(x => x.KorisnikId == entity.KorisnikId);
            if (biblioteka != null)
                mapped.BibliotekaId = biblioteka.BibliotekaId;

            return mapped;
        }

        public async Task<Model.KorisniciDTOs.Korisnici> GetInfo(CancellationToken cancellationToken = default)
        {
            var currentUserId = await currentUserService.GetUserIdAsync();
            if (currentUserId == null)
                throw new UserException("Greška sa korisnkom!");
            
            var user = await Context.Korisnicis.FirstOrDefaultAsync(x=>x.KorisnikId==currentUserId);

            return Mapper.Map<Model.KorisniciDTOs.Korisnici>(user);
        }
    }
}
