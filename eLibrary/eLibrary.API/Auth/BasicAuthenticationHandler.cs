using eLibrary.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using Microsoft.Identity.Client;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace eLibrary.API.Auth
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IKorisniciService _korisniciService;
        private readonly ICitaociService _citaociService;

        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder, 
            ISystemClock clock,
            IKorisniciService korisniciService,
            ICitaociService citaociService) : base(options, logger, encoder, clock)
        {
            _korisniciService = korisniciService;
            this._citaociService = citaociService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing header");
            }

            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var credentialBytes=Convert.FromBase64String(authHeader.Parameter);
            var credentials = Encoding.UTF8.GetString(credentialBytes).Split(':');

            var username=credentials[0];
            var password=credentials[1];

            var user=_korisniciService.Login(username, password);

            if (user == null)
            {
                //potrebna provjera da li je citaoc, te ako nije vracamo fail
                var citalac = _citaociService.Login(username, password);

                if (citalac == null)
                {
                    return AuthenticateResult.Fail("Auth failed");
                }
                else
                {
                    var claims = new List<Claim>()
                    {
                    new Claim(ClaimTypes.Name, citalac.Ime),
                    new Claim(ClaimTypes.NameIdentifier, citalac.KorisnickoIme)
                    };

                    claims.Add(new Claim(ClaimTypes.Role, "Citalac"));                   

                    var identity = new ClaimsIdentity(claims, Scheme.Name);

                    var principal = new ClaimsPrincipal(identity);

                    var ticket = new AuthenticationTicket(principal, Scheme.Name);
                    return AuthenticateResult.Success(ticket);
                }           
            }
            else
            {                
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Name, user.Ime),
                    new Claim(ClaimTypes.NameIdentifier, user.KorisnickoIme)
                };

                foreach (var role in user.KorisniciUloges)
                {
                    claims.Add(new Claim(ClaimTypes.Role, role.Uloga.Naziv));
                }

                var identity = new ClaimsIdentity(claims, Scheme.Name);

                var principal = new ClaimsPrincipal(identity);

                var ticket = new AuthenticationTicket(principal, Scheme.Name);
                return AuthenticateResult.Success(ticket);
            }
        }
    }
}
