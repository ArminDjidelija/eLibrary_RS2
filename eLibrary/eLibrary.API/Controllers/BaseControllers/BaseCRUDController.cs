using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers.BaseControllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BaseCRUDController<TModel, TSearch, TInsert, TUpdate> : BaseController<TModel, TSearch> where TSearch : BaseSearchObject where TModel : class
    {
        protected new ICRUDService<TModel, TSearch, TInsert, TUpdate> _service;

        public BaseCRUDController(ICRUDService<TModel, TSearch, TInsert, TUpdate> service) : base(service)
        {
            _service = service;
        }

        [HttpPost]
        public virtual Task<TModel> Insert(TInsert request, CancellationToken cancellationToken = default)
        {
            return _service.InsertAsync(request, cancellationToken);
        }

        [HttpPut("{id}")]
        public virtual Task<TModel> Update(int id, TUpdate request, CancellationToken cancellationToken = default)
        {
            return _service.UpdateAsync(id, request, cancellationToken);
        }

        [HttpDelete("{id}")]
        public virtual Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return _service.DeleteAsync(id, cancellationToken);
        }
    }
}
