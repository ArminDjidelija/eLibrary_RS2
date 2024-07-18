using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class KorisniciController : BaseCRUDControllerAsync<Model.KorisniciDTOs.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        public KorisniciController(IKorisniciService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public Model.KorisniciDTOs.Korisnici Login(string username, string password)
        {
            return (_service as IKorisniciService).Login(username, password);
        }
    }
}
