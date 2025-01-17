using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class AutoriController : BaseCRUDControllerAsync<Model.AutoriDTOs.Autori, AutoriSearchObject, AutoriUpsertRequest, AutoriUpsertRequest>
    {
        public AutoriController(IAutoriService service) : base(service)
        {
        }
    }
}
