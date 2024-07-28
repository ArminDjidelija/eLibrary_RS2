using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.IBaseValidator
{
    public interface IBaseValidator<TEntity>
        where TEntity : class
    {
        void ValidateEntityExists(int id);
        void ValidateNoDuplicates(List<int> array);
    }
}
