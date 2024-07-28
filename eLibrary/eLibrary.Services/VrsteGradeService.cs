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
    public class VrsteGradeService : BaseCRUDServiceAsync<Model.VrsteGradeDTOs.VrsteGrade, VrsteGradeSearchObject, Database.VrsteGrade, VrsteGradeUpsertRequest, VrsteGradeUpsertRequest>, IVrsteGradeService
    {
        public VrsteGradeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<VrsteGrade> AddFilter(VrsteGradeSearchObject search, IQueryable<VrsteGrade> query)
        {
            if (!string.IsNullOrEmpty(search?.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }
            return query;
        }
    }
}
