using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Model.UplateDTOs;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class UplateController : BaseCRUDControllerAsync<Model.UplateDTOs.Uplate, UplateSearchObject, UplateInsertRequest, UplateUpdateRequest>
    {
        public UplateController(IUplateService service) : base(service)
        {
        }
    }
}
