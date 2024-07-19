using eLibrary.Services.Database;
using Microsoft.AspNetCore.Http;
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
    public class CurrentUserService:ICurrentUserService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ELibraryContext _context;

        public CurrentUserService(IHttpContextAccessor httpContextAccessor, ELibraryContext context)
        {
            this._httpContextAccessor = httpContextAccessor;
            this._context = context;
        }

        public int? GetCitaocId()
        {
            var citaocPrincipal = _httpContextAccessor.HttpContext?.User;
            var role = citaocPrincipal?.FindFirstValue(ClaimTypes.Role);
            if (role == "Citalac")
            {
                var username = citaocPrincipal?.FindFirstValue(ClaimTypes.NameIdentifier);
                var citaoc = _context.Citaocis.Find(username);
                return citaoc.CitalacId;
            }
            return null;
        }

        public int? GetUserId()
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

        public string? GetUserName()
        {
            var korisnikPrincipal = _httpContextAccessor.HttpContext?.User;
            var username = korisnikPrincipal?.FindFirstValue(ClaimTypes.NameIdentifier);
            return username;
        }

        public string? GetUserType()
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
