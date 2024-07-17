using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Model.VrsteSadrzajaDTO;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class VrsteSadrzajaController : BaseCRUDControllerAsync<VrsteSadrzaja, VrsteSadrzajaSearchObject, VrsteSadrzajaUpsertRequest, VrsteSadrzajaUpsertRequest>
    {
        public VrsteSadrzajaController(IVrsteSadrzajaService service) : base(service)
        {
        }
    }
}
