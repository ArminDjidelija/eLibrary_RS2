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
    public class BaseCRUDService<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseService<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        public BaseCRUDService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual TModel Insert(TInsert request)
        {
            TDbEntity entity = Mapper.Map<TDbEntity>(request);

            BeforeInsert(request, entity);

            Context.Add(entity);
            Context.SaveChanges();
            AfterInsert(request, entity);
            return Mapper.Map<TModel>(entity);
        }
        public virtual void BeforeInsert(TInsert request, TDbEntity entity) { }
        public virtual void AfterInsert(TInsert request, TDbEntity entity) { }

        public virtual TModel Update(int id, TUpdate request)
        {
            var set = Context.Set<TDbEntity>();

            var entity = set.Find(id);

            Mapper.Map(request, entity);

            BeforeUpdate(request, entity);

            Context.SaveChanges();

            AfterUpdate(request, entity);

            return Mapper.Map<TModel>(entity);
        }

        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity) { }
        public virtual void AfterUpdate(TUpdate request, TDbEntity entity) { }

        public virtual void Delete(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);
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

            Context.SaveChanges();

            AfterDelete(entity);
        }

        public virtual void AfterDelete(TDbEntity entity) { }
    }
}
