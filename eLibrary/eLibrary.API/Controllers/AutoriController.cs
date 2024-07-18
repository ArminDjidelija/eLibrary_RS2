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

        [AllowAnonymous]
        public override Task<PagedResult<Model.AutoriDTOs.Autori>> GetList([FromQuery] AutoriSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<Model.AutoriDTOs.Autori> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }
    }
}
