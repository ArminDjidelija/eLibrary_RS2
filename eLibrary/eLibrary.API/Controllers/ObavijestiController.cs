using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.ObavijestiDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class ObavijestiController : BaseCRUDControllerAsync<Model.ObavijestiDTOs.Obavijesti, ObavijestiSearchObject, ObavijestiInsertRequest, ObavijestiUpdateRequest>
    {
        public ObavijestiController(IObavijestiService service) : base(service)
        {
        }
    }
}
