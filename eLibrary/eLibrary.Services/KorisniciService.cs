﻿using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Security.Cryptography;
using System.Text;

namespace eLibrary.Services
{
    public class KorisniciService : BaseCRUDServiceAsync<Model.KorisniciDTOs.Korisnici, KorisniciSearchObject, Database.Korisnici, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        private readonly ILogger<KorisniciService> _logger;
        private readonly IPasswordService _passwordService;

        public KorisniciService(ELibraryContext context, 
            IMapper mapper, 
            ILogger<KorisniciService> logger,
            IPasswordService passwordService) : base(context, mapper)
        {
            _logger = logger;
            this._passwordService = passwordService;
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

            if (!string.IsNullOrEmpty(search?.Email))
            {
                query = query.Where(x => x.Email == search.Email);
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

            entity.LozinkaSalt = _passwordService.GenerateSalt();
            entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);
        }

        public override async Task AfterInsertAsync(KorisniciInsertRequest request, Korisnici entity, CancellationToken cancellationToken = default)
        {
            if (request.Uloge != null)
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
                if (request.Lozinka == request.LozinkaPotvrda)
                {
                    entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);
                }
            }
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

            var hash= _passwordService.GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return this.Mapper.Map<Model.KorisniciDTOs.Korisnici>(entity);
        }
    }
}