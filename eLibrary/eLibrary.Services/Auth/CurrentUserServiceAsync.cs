using eLibrary.Model.Exceptions;
using eLibrary.Services.Database;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.Auth
{
    public class CurrentUserServiceAsync : ICurrentUserServiceAsync
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ELibraryContext _context;

        public CurrentUserServiceAsync(IHttpContextAccessor httpContextAccessor, ELibraryContext context)
        {
            _httpContextAccessor = httpContextAccessor;
            _context = context;
        }

        public async Task<int> GetBibliotekaIdFromUserAsync(CancellationToken cancellationToken = default)
        {
            var userId = await GetUserIdAsync(cancellationToken);
            if(userId == null)
            {
                throw new UserException("Niste prijavljeni!");
            }
            var biblioteka = await _context.BibliotekaUposlenis.FirstOrDefaultAsync(x=>x.KorisnikId== userId, cancellationToken);
            if(biblioteka==null)
            {
                throw new UserException("Ne postoji biblioteka za ovog korisnika!");
            }
            return biblioteka.BibliotekaId;
        }

        public async Task<int?> GetCitaocIdAsync(CancellationToken cancellationToken = default)
        {
            var citaocPrincipal = _httpContextAccessor.HttpContext?.User;
            var role = citaocPrincipal?.FindFirstValue(ClaimTypes.Role);
            if (role == "Citalac")
            {
                var username = citaocPrincipal?.FindFirstValue(ClaimTypes.NameIdentifier);
                var citalac = await _context.Citaocis.FirstOrDefaultAsync(x=>x.KorisnickoIme==username);
                return citalac.CitalacId;
            }
            return null;
        }

        public async Task<int?> GetUserIdAsync(CancellationToken cancellationToken = default)
        {
            var korisnikPrincipal = _httpContextAccessor.HttpContext?.User;
            var role = korisnikPrincipal?.FindFirstValue(ClaimTypes.Role);
            var uloge = _context.Uloges.Select(x=>x.Naziv).ToList();
            if (uloge.Contains(role))
            {
                var username = korisnikPrincipal?.FindFirstValue(ClaimTypes.NameIdentifier);
                var citaoc = _context.Korisnicis.Where(x=>x.KorisnickoIme==username).FirstOrDefault();
                if (citaoc == null) return null;
                return citaoc.KorisnikId;
            }
            return null;
        }

        public async Task<string?> GetUserNameAsync(CancellationToken cancellationToken = default)
        {
            var korisnikPrincipal = _httpContextAccessor.HttpContext?.User;
            var username = korisnikPrincipal?.FindFirstValue(ClaimTypes.NameIdentifier);
            return username;
        }

        public async Task<string?> GetUserTypeAsync(CancellationToken cancellationToken = default)
        {
            var principal = _httpContextAccessor.HttpContext?.User;
            var role = principal?.FindFirstValue(ClaimTypes.Role);
            if (role == "Citalac")
            {
                return "Citalac";
            }
            var uloge = _context.Uloges.Select(x => x.Naziv).ToList();
            if (uloge.Contains(role))
            {
                return role;
            }
            return null;
        }
    }
}
