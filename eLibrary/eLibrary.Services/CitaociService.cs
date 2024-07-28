using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class CitaociService : BaseCRUDServiceAsync<Model.CitaociDTOs.Citaoci, CitaociSearchObject, Database.Citaoci, CitaociInsertRequest, CitaociUpdateRequest>, ICitaociService
    {
        private readonly ILogger<CitaociService> _logger;
        private readonly IPasswordService _passwordService;

        public CitaociService(ELibraryContext context,
            IMapper mapper,
            ILogger<CitaociService> logger,
            IPasswordService passwordService) : base(context, mapper)
        {
            this._logger = logger;
            this._passwordService = passwordService;
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

            if (string.IsNullOrEmpty(request.Lozinka) || string.IsNullOrEmpty(request.LozinkaPotvrda))
                throw new UserException("Lozinka i potvrda lozinke moraju imati vrijednost");

            if (request.Lozinka != request.LozinkaPotvrda)
                throw new UserException("Lozinka i potvrda lozinke moraju biti iste");

            entity.LozinkaSalt = _passwordService.GenerateSalt();
            entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);

            entity.Status = true;
            entity.DatumRegistracije = DateTime.Now;
        }

        public override async Task BeforeUpdateAsync(CitaociUpdateRequest request, Citaoci entity, CancellationToken cancellationToken = default)
        {
            if (request.Lozinka != null && request.LozinkaPotvrda != null)
            {
                if (request.Lozinka == request.LozinkaPotvrda)
                {
                    entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);
                }
            }
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
    }
}
