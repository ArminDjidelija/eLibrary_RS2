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
    public class CiljneGrupeService : BaseCRUDServiceAsync<Model.CiljneGrupeDTOs.CiljneGrupe, CiljnaGrupaSearchObject, Database.CiljneGrupe, CiljnaGrupaUpsertRequest, CiljnaGrupaUpsertRequest>, ICiljneGrupeService
    {
        public CiljneGrupeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<CiljneGrupe> AddFilter(CiljnaGrupaSearchObject search, IQueryable<CiljneGrupe> query)
        {
            if(!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }
            return query;
        }

    }
}
