using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    [AllowAnonymous]
    public class KantoniController : BaseControllerAsync<Model.KantoniDTOs.Kantoni, KantoniSearchObject>
    {
        public KantoniController(IKantoniService service) : base(service)
        {
        }
    }
}
