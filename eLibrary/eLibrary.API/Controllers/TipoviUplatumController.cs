using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.SearchObjects;
using eLibrary.Model.TipoviUplatumDTOs;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class TipoviUplatumController : BaseControllerAsync<Model.TipoviUplatumDTOs.TipoviUplata, TipoviUplataSearchObject>
    {
        public TipoviUplatumController(ITipoviUplatumService service) : base(service)
        {
        }
    }
}
