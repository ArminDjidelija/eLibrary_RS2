using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class JeziciController : BaseCRUDControllerAsync<Model.JeziciDTOs.Jezici, JeziciSearchObject, JeziciUpsertRequest, JeziciUpsertRequest>
    {
        public JeziciController(IJeziciService service) : base(service)
        {
        }
    }
}
