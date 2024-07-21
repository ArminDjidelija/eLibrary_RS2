using eLibrary.Model.Exceptions;
using eLibrary.Services.Database;
using eLibrary.Services.IBaseValidator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.Validators
{
    public class BaseValidatorService<TEntity> : IBaseValidator<TEntity> where TEntity : class
    {
        private readonly ELibraryContext context;

        public BaseValidatorService(ELibraryContext context)
        {
            this.context = context;
        }
        public virtual void ValidateEntityExists(int id)
        {
            TEntity entity = context.Set<TEntity>().Find(id);

            if (entity == null)
                throw new UserException($"Ne postoji {typeof(TEntity).Name} sa id: {id}");
        }
        public void ValidateNoDuplicates(List<int> array)
        {
            if (array.Count() > 0)
            {
                if (array.Count() != array.Distinct().Count())
                {
                    throw new UserException($"Lista {typeof(TEntity).Name} ima duplikate!");
                }
            }
        }

    }
}
