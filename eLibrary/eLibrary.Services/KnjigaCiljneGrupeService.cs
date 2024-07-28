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
    public class KnjigaCiljneGrupeService : BaseCRUDServiceAsync<Model.KnjigaCiljneGrupeDTOs.KnjigaCiljneGrupe, KnjigaCiljneGrupeSearchObject, Database.KnjigaCiljneGrupe, KnjigaCiljneGrupeInsertRequest, KnjigaCiljneGrupeUpdateRequest>, IKnjigaCiljneGrupeService
    {
        public KnjigaCiljneGrupeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<KnjigaCiljneGrupe> AddFilter(KnjigaCiljneGrupeSearchObject search, IQueryable<KnjigaCiljneGrupe> query)
        {
            if (search?.CiljnaGrupaId != null)
            {
                query=query.Where(x=>x.CiljnaGrupaId==search.CiljnaGrupaId);
            }
            if(search?.KnjigaId != null)
            {
                query=query.Where(x=>x.KnjigaId==search.KnjigaId);
            }
            return query;
        }
    }
}
