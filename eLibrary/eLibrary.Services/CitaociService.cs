using eLibrary.Model.Exceptions;
using eLibrary.Model.Messages;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using eLibrary.Services.RabbitMqService;
using eLibrary.Services.Recommender;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace eLibrary.Services
{
    public class CitaociService : BaseCRUDServiceAsync<Model.CitaociDTOs.Citaoci, CitaociSearchObject, Database.Citaoci, CitaociInsertRequest, CitaociUpdateRequest>, ICitaociService
    {
        private readonly ILogger<CitaociService> _logger;
        private readonly IPasswordService _passwordService;
        private readonly IRecommendService recommendService;
        private readonly ICurrentUserServiceAsync currentUserService;
        private readonly IRabbitMqService rabbitMqService;

        public CitaociService(ELibraryContext context,
            IMapper mapper,
            ILogger<CitaociService> logger,
            IPasswordService passwordService,
            IRecommendService recommendService,
            ICurrentUserServiceAsync currentUserService,
            IRabbitMqService rabbitMqService) : base(context, mapper)
        {
            this._logger = logger;
            this._passwordService = passwordService;
            this.recommendService = recommendService;
            this.currentUserService = currentUserService;
            this.rabbitMqService = rabbitMqService;
        }
        public override IQueryable<Citaoci> AddFilter(CitaociSearchObject search, IQueryable<Citaoci> query)
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

            if (!string.IsNullOrEmpty(search?.InstitucijaGTE))
            {
                query = query.Where(x => x.Institucija.ToLower().StartsWith(search.InstitucijaGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.EmailContains))
            {
                query = query.Where(x => x.Email.ToLower().Contains(search.EmailContains.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.KorisnickoIme))
            {
                query = query.Where(x => x.KorisnickoIme == search.KorisnickoIme);
            }

            if (search.Status != null)
            {
                query = query.Where(x => x.Status == search.Status);
            }

            return query;
        }

        public override async Task BeforeInsertAsync(CitaociInsertRequest request, Citaoci entity, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation($"Adding citaoc: {entity.KorisnickoIme}");

            //if (string.IsNullOrEmpty(request.Lozinka) || string.IsNullOrEmpty(request.LozinkaPotvrda))
            //    throw new UserException("Lozinka i potvrda lozinke moraju imati vrijednost");

            //if (request.Lozinka != request.LozinkaPotvrda)
            //    throw new UserException("Lozinka i potvrda lozinke moraju biti iste");

            var existing = await Context.Citaocis.FirstOrDefaultAsync(x => x.KorisnickoIme == request.KorisnickoIme);
            if (existing != null)
                throw new UserException("Čitalac sa ovim korisničkim imenom već postoji");

            entity.Status = true;
            entity.DatumRegistracije = DateTime.Now;

            var lozinka = _passwordService.GenerateRandomString(8);

            entity.LozinkaSalt = _passwordService.GenerateSalt();
            entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, lozinka);

            await rabbitMqService.SendAnEmail(new EmailDTO
            {
                EmailTo = entity.Email,
                Message = $"Poštovani<br>" +
                         $"Korisnicko ime: {entity.KorisnickoIme}<br>" +
                         $"Lozinka: {lozinka}<br><br>" +
                         $"Srdačan pozdrav",
                ReceiverName = entity.Ime + " " + entity.Prezime,
                Subject = "Registracija"
            });
        }

        public override async Task BeforeUpdateAsync(CitaociUpdateRequest request, Citaoci entity, CancellationToken cancellationToken = default)
        {
            if(request.Lozinka != null)
            {
                var passwordCheck = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka) == entity.LozinkaHash;
                if (passwordCheck == false)
                {
                    throw new UserException("Pogrešna stara lozinka");
                }
                if (request.NovaLozinka != null && request.LozinkaPotvrda != null)
                {
                    if (request.NovaLozinka == request.LozinkaPotvrda)
                    {
                        entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);
                    }
                    else
                    {
                        throw new UserException("Nova lozinka se ne poklapa sa potvrdom!");
                    }
                }
            }
        }

        public async Task<Model.CitaociDTOs.Citaoci> GetInfo(CancellationToken cancellationToken = default)
        {
            var citalacId = await currentUserService.GetCitaocIdAsync(cancellationToken);
            if(citalacId == null)
            {
                throw new UserException("Greška sa čitaocem");
            }
            var citalac = await Context.Citaocis.FirstOrDefaultAsync(x=>x.CitalacId == citalacId);
            return Mapper.Map<Model.CitaociDTOs.Citaoci>(citalac);
        }

        public Model.CitaociDTOs.Citaoci Login(string username, string password)
        {
            var entity = Context
                .Citaocis
                .FirstOrDefault(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = _passwordService.GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return this.Mapper.Map<Model.CitaociDTOs.Citaoci>(entity);
        }

        public async Task<List<Model.KnjigeDTOs.Knjige>> Recommend(int id)
        {
            var knjige = await recommendService.GetRecommendedBooks(id);
            return knjige;
        }

        public void TrainData()
        {
            recommendService.TrainData();
        }
    }
}
