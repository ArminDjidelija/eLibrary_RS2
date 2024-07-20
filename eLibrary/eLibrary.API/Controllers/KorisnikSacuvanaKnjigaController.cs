using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.KorisnikSacuvaneKnjigeDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class KorisnikSacuvanaKnjigaController : BaseCRUDControllerAsync<Model.KorisnikSacuvaneKnjigeDTOs.KorisnikSacuvaneKnjige, KorisnikSacuvanaKnjigaSearchObject, KorisnikSacuvanaKnjigaInsertRequest, KorisnikSacuvanaKnjigaUpdateRequest>
    {
        public KorisnikSacuvanaKnjigaController(IKorisnikSacuvanaKnjigaService service) : base(service)
        {
        }
    }
}
