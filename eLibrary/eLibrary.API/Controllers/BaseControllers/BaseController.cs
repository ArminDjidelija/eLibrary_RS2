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
        [ProducesResponseType(StatusCodes.Status200OK)]
        public virtual PagedResult<TModel> GetList([FromQuery] TSearch searchObject)
        {
            return _service.GetPaged(searchObject);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public virtual TModel GetById(int id)
        {
            return _service.GetById(id);
        }

    }
}
