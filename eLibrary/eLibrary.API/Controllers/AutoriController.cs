using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.AutoriDTO;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class AutoriController : BaseCRUDControllerAsync<Model.AutoriDTO.Autori, AutoriSearchObject, AutoriUpsertRequest, AutoriUpsertRequest>
    {
        public AutoriController(IAutoriService service) : base(service)
        {
        }
    }
}
