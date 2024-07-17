using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.KantoniDTO;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class KantoniController : BaseControllerAsync<Model.KantoniDTO.Kantoni, KantoniSearchObject>
    {
        public KantoniController(IKantoniService service) : base(service)
        {
        }
    }
}
