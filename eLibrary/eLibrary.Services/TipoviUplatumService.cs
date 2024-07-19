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
    public class TipoviUplatumService : BaseServiceAsync<Model.TipoviUplatumDTOs.TipoviUplata, TipoviUplataSearchObject, Database.TipoviUplatum>, ITipoviUplatumService
    {
        public TipoviUplatumService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
