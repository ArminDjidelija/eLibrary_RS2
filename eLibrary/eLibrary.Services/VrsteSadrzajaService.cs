using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class VrsteSadrzajaService : BaseCRUDServiceAsync<Model.VrsteSadrzajaDTO.VrsteSadrzaja, VrsteSadrzajaSearchObject, Database.VrsteSadrzaja, VrsteSadrzajaUpsertRequest, VrsteSadrzajaUpsertRequest>, IVrsteSadrzajaService
    {
        public VrsteSadrzajaService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
