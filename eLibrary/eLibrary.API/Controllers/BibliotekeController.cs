using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    public class BibliotekeController : BaseCRUDControllerAsync<Model.BibliotekeDTOs.Biblioteke, BibliotekeSearchObject, BibliotekeUpsertRequest, BibliotekeUpsertRequest>
    {
        public BibliotekeController(IBibliotekeService service) : base(service)
        {
        }

        [AllowAnonymous]
        public override Task<PagedResult<Model.BibliotekeDTOs.Biblioteke>> GetList([FromQuery] BibliotekeSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<Model.BibliotekeDTOs.Biblioteke> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }
    }
}
