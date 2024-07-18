using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServices;
using eLibrary.Services.BaseServicesInterfaces;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Storage;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class ValuteController : BaseCRUDControllerAsync<Model.ValuteDTOs.Valute, ValuteSearchObject, ValuteUpsertRequest, ValuteUpsertRequest>
    {
        public ValuteController(IValuteService service) : base(service)
        {
        }
    }
}
