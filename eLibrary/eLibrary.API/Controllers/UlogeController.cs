using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    [AllowAnonymous]
    public class UlogeController : BaseControllerAsync<Model.UlogeDTOs.Uloge, UlogeSearchObject>
    {
        public UlogeController(IUlogeService service) : base(service)
        {
        }
    }
}
