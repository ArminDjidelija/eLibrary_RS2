using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Model.UpitiDTO;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class UpitiController : BaseCRUDControllerAsync<Model.UpitiDTO.Upiti, UpitiSearchObject, UpitiInsertRequest, UpitiUpdateRequest>
    {
        public UpitiController(IUpitiService service) : base(service)
        {
        }
    }
}
