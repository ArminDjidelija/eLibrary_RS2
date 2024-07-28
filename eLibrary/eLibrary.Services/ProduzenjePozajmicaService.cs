using eLibrary.Model.Exceptions;
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
    public class ProduzenjePozajmicaService : BaseCRUDServiceAsync<Model.ProduzenjePozajmicaDTOs.ProduzenjePozajmica, ProduzenjePozajmicaSearchObject, Database.ProduženjePozajmica, ProduzenjePozajmicaInsertRequest, ProduzenjePozajmicaUpdateRequest>, IProduzenjePozajmicaService
    {
        public ProduzenjePozajmicaService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<ProduženjePozajmica> AddFilter(ProduzenjePozajmicaSearchObject search, IQueryable<ProduženjePozajmica> query)
        {
            if (search?.PozajmicaId != null)
            {
                query=query.Where(x=>x.PozajmicaId==search.PozajmicaId);
            }
            if (search?.Odobreno != null)
            {
                query=query.Where(x=>x.Odobreno==search.Odobreno);
            }
            return query;
        }

        public override async Task BeforeInsertAsync(ProduzenjePozajmicaInsertRequest request, ProduženjePozajmica entity, CancellationToken cancellationToken = default)
        {
            if(request.Produzenje<1 || request.Produzenje > 365)
            {
                throw new UserException("Trajanje mora biti u vrijednosti od 1 do 365 dana!");
            }
            entity.DatumZahtjeva = DateTime.Now;
            entity.NoviRok = entity.DatumZahtjeva.AddDays(request.Produzenje);
        }
    }
}
