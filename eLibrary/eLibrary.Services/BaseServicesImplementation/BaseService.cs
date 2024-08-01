using eLibrary.Model;
using eLibrary.Model.Exceptions;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using System.Reflection.Metadata.Ecma335;

namespace eLibrary.Services.BaseServices
{
    public class BaseService<TModel, TSearch, TDbEntity> : IService<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
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

            if (!string.IsNullOrEmpty(search?.IncludeTables))
            {
                query = ApplyIncludes(query, search.IncludeTables);
            }
            query = AddFilter(search, query);

            int count = query.Count();

            if (!string.IsNullOrEmpty(search?.OrderBy) && !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection);
            }

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true && (search?.RetrieveAll.HasValue == false || search?.RetrieveAll == null))
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = query.ToList();

            result = Mapper.Map(list, result);
            CustomMapPagedResponse(result);

            PagedResult<TModel> pagedResult = new PagedResult<TModel>();
            pagedResult.ResultList = result;
            pagedResult.Count = count;

            return pagedResult;
        }

        public virtual void CustomMapPagedResponse(List<TModel> result) { }

        private IQueryable<TDbEntity> ApplyIncludes(IQueryable<TDbEntity> query, string includes)
        {
            try
            {
                var tableIncludes=includes.Split(',');
                query = tableIncludes.Aggregate(query, (current, inc) => current.Include(inc));
            }
            catch (Exception)
            {
                throw new UserException("Pogrešna include lista!");
            }

            return query;
        }

        public IQueryable<TDbEntity> ApplySorting(IQueryable<TDbEntity> query, string sortColumn, string sortDirection)
        {
            var entityType = typeof(TDbEntity);
            var property = entityType.GetProperty(sortColumn);
            if (property != null)
            {
                var parameter = Expression.Parameter(entityType, "x");
                var propertyAccess = Expression.MakeMemberAccess(parameter, property);
                var orderByExpression = Expression.Lambda(propertyAccess, parameter);

                string methodName = "";

                var sortDirectionToLower = sortDirection.ToLower();

                methodName = sortDirectionToLower == "desc" || sortDirectionToLower == "descending" ? "OrderByDescending" :
                    sortDirectionToLower == "asc" || sortDirectionToLower == "ascending" ? "OrderBy" : "";

                if (methodName == "")
                {
                    return query;
                }

                var resultExpression = Expression.Call(typeof(Queryable), methodName,
                                                       new Type[] { entityType, property.PropertyType },
                                                       query.Expression, Expression.Quote(orderByExpression));

                return query.Provider.CreateQuery<TDbEntity>(resultExpression);
            }
            else
            {
                return query;
            }
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
                var mappedObj = Mapper.Map<TModel>(entity);
                CustomMapResponse(mappedObj);
                return mappedObj;
            }
            else
            {
                return null;
            }
        }

        public virtual void CustomMapResponse(TModel mappedObj) { }

        //public TModel GetFirstOrDefaultForSearchObject(TSearch search)
        //{
        //    var query = Context.Set<TDbEntity>().AsQueryable();

        //    query=ApplyGetFirstOrDefaultForSearchObject(query, search);

        //    var entity = query.FirstOrDefault();
        //    if (entity != null)
        //    {
        //        return Mapper.Map<TModel>(entity);
        //    }

        //    return null;
        //}

        //public virtual IQueryable<TDbEntity> ApplyGetFirstOrDefaultForSearchObject(IQueryable<TDbEntity> query, TSearch search)
        //{
        //    return query;
        //}
    }
}
