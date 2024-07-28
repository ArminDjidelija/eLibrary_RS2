using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.KnjigaAutoriDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class KnjigaAutoriController : BaseCRUDControllerAsync<Model.KnjigaAutoriDTOs.KnjigaAutori, KnjigaAutoriSearchObject, KnjigaAutoriUpsertRequest, KnjigaAutoriUpsertRequest>
    {
        public KnjigaAutoriController(IKnjigaAutoriService service) : base(service)
        {
        }
    }
}
