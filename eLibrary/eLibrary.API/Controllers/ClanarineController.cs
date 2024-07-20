using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.ClanarineDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class ClanarineController : BaseCRUDControllerAsync<Model.ClanarineDTOs.Clanarine, ClanarineSearchObject, ClanarineInsertRequest, ClanarineUpdateRequest>
    {
        public ClanarineController(IClanarineService service) : base(service)
        {
        }
    }
}
