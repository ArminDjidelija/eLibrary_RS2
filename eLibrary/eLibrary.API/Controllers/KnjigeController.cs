using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.KnjigeDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class KnjigeController : BaseCRUDControllerAsync<Model.KnjigeDTOs.Knjige, KnjigeSearchObject, KnjigeInsertRequest, KnjigeUpdateRequest>
    {
        public KnjigeController(IKnjigeService service) : base(service)
        {
        }

    
    }
}
