using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Model.UveziDTOs;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class UveziController : BaseCRUDControllerAsync<Model.UveziDTOs.Uvezi, UveziSearchObject, UveziUpsertRequest, UveziUpsertRequest>
    {
        public UveziController(IUveziService service) : base(service)
        {
        }
    }
}
