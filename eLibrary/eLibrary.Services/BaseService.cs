using eLibrary.Model;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class BaseService <TModel, TSearch, TDbEntity>:IService<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel: class
    {
        public ELibraryContext Context { get; }
        public IMapper Mapper { get; }

        public BaseService(ELibraryContext context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }

        public PagedResult<TModel> GetPaged(TSearch search)
        {
            List<TModel> result = new List<TModel>();

            var query = Context.Set<TDbEntity>().AsQueryable();

            query = AddFilter(search, query);

            int count = query.Count();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true && (search?.RetrieveAll.HasValue == false || search?.RetrieveAll == null))
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = query.ToList();

            result = Mapper.Map(list, result);

            PagedResult<TModel> pagedResult = new PagedResult<TModel>();
            pagedResult.ResultList = result;
            pagedResult.Count = count;

            return pagedResult;
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }


        public TModel GetById(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);

            if (entity != null)
            {
                return Mapper.Map<TModel>(entity);
            }
            else
            {
                return null;
            }
        }
    }
}
