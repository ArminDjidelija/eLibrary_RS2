using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AutoriController : BaseCRUDController<Autori, AutoriSearchObject, AutoriUpsertRequest, AutoriUpsertRequest>
    {
        public AutoriController(IAutoriService service) : base(service)
        {
        }
    }
}
