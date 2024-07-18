using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
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

        public KorisniciService(ELibraryContext context, IMapper mapper, ILogger<KorisniciService> logger) : base(context, mapper)
        {
            _logger = logger;
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
                query = query.Where(x => x.Prezime.ToLower().StartsWith(search.PrezimeGTE.ToLower()));
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

            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
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
                    entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
                }
            }
        }

        public static string GenerateSalt()
        {
            var byteArray = RandomNumberGenerator.GetBytes(16);
            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public static string GenerateRandomString(int size)
        {
            // Characters except I, l, O, 1, and 0 to decrease confusion when hand typing tokens
            var charSet = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@_-$#";
            var chars = charSet.ToCharArray();
            var data = new byte[1];
#pragma warning disable SYSLIB0023 // Type or member is obsolete
            var crypto = new RNGCryptoServiceProvider();
#pragma warning restore SYSLIB0023 // Type or member is obsolete
            crypto.GetNonZeroBytes(data);
            data = new byte[size];
            crypto.GetNonZeroBytes(data);
            var result = new StringBuilder(size);
            foreach (var b in data)
            {
                result.Append(chars[b % (chars.Length)]);
            }

            return result.ToString();
        }

        public Model.KorisniciDTOs.Korisnici Login(string username, string password)
        {
            var entity = Context
                .Korisnicis
                .Include(x => x.KorisniciUloges)
                    .ThenInclude(y => y.Uloga)
                .FirstOrDefault(x => x.KorisnickoIme == username);

            if(entity==null)
            {
                return null; 
            }

            var hash=GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return this.Mapper.Map<Model.KorisniciDTOs.Korisnici>(entity);

        }
    }
}
