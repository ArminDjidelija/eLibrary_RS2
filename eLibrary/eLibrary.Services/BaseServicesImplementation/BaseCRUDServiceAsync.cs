using eLibrary.Model.Exceptions;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace eLibrary.Services.BaseServices
{
    public class BaseCRUDServiceAsync<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseServiceAsync<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        public BaseCRUDServiceAsync(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task<TModel> InsertAsync(TInsert request, CancellationToken cancellationToken = default)
        {
            TDbEntity entity = Mapper.Map<TDbEntity>(request);

            BeforeInsert(request, entity);

            Context.Add(entity);
            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<TModel>(entity);
        }
        public virtual void BeforeInsert(TInsert request, TDbEntity entity) { }

        public virtual async Task<TModel> UpdateAsync(int id, TUpdate request, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<TDbEntity>();

            var entity = await set.FindAsync(id, cancellationToken);

            Mapper.Map(request, entity);

            BeforeUpdate(request, entity);

            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<TModel>(entity);
        }

        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity) { }

        public virtual async Task DeleteAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await Context.Set<TDbEntity>().FindAsync(id, cancellationToken);
            if (entity == null)
            {
                throw new UserException("Nemoguće pronaći objekat sa poslanim id-om!");
            }

            if (entity is ISoftDeletable softDeleteEntity)
            {
                softDeleteEntity.IsDeleted = true;
                softDeleteEntity.VrijemeBrisanja = DateTime.Now;
                Context.Update(entity);
            }
            else
            {
                Context.Remove(entity);
            }

            await Context.SaveChangesAsync(cancellationToken);
        }
    }
}
