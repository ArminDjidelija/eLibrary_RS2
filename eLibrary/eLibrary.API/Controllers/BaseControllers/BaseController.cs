using eLibrary.Model;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;
using System.Threading;

namespace eLibrary.API.Controllers.BaseControllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BaseController<TModel, TSearch> : ControllerBase where TSearch : BaseSearchObject
    {
        private readonly IService<TModel, TSearch> _service;

        public BaseController(IService<TModel, TSearch> service)
        {
            _service = service;
        }

        [HttpGet]
        public virtual Task<PagedResult<TModel>> GetList([FromQuery] TSearch searchObject, CancellationToken cancellationToken = default)
        {
            return _service.GetPagedAsync(searchObject, cancellationToken);
        }

        [HttpGet("{id}")]
        public virtual Task<TModel> GetById(int id, CancellationToken cancellationToken = default)
        {
            return _service.GetByIdAsync(id, cancellationToken);
        }
    }
}
