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
    public class KnjigaVrsteSadrzajaService : BaseCRUDServiceAsync<Model.KnjigaVrsteSadrzajaDTOs.KnjigaVrsteSadrzaja, KnjigaVrsteSadrzajaSearchObject, Database.KnjigaVrsteSadrzaja, KnjigaVrsteSadrzajaInsertRequest, KnjigaVrsteSadrzajaUpdateRequest>, IKnjigaVrsteSadrzajaService
    {
        public KnjigaVrsteSadrzajaService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<KnjigaVrsteSadrzaja> AddFilter(KnjigaVrsteSadrzajaSearchObject search, IQueryable<KnjigaVrsteSadrzaja> query)
        {
            if(search?.KnjigaId!= null) 
            {
                query=query.Where(x=>x.KnjigaId==search.KnjigaId);
            }
            if(search?.VrstaSadrzajaId!= null)
            {
                query=query.Where(x=>x.VrstaSadrzajaId==search.VrstaSadrzajaId);
            }
            return query;
        }
    }
}
