using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.KnjigaVrsteSadrzajaDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class KnjigaVrsteSadrzajaController : BaseCRUDControllerAsync<Model.KnjigaVrsteSadrzajaDTOs.KnjigaVrsteSadrzaja, KnjigaVrsteSadrzajaSearchObject, KnjigaVrsteSadrzajaInsertRequest, KnjigaVrsteSadrzajaUpdateRequest>
    {
        public KnjigaVrsteSadrzajaController(IKnjigaVrsteSadrzajaService service) : base(service)
        {
        }
    }
}
