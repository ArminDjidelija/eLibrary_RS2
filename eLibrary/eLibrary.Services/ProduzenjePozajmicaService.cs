using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class ProduzenjePozajmicaService : BaseCRUDServiceAsync<Model.ProduzenjePozajmicaDTOs.ProduzenjePozajmica, ProduzenjePozajmicaSearchObject, Database.ProduzenjePozajmica, ProduzenjePozajmicaInsertRequest, ProduzenjePozajmicaUpdateRequest>, IProduzenjePozajmicaService
    {
        public ProduzenjePozajmicaService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<ProduzenjePozajmica> AddFilter(ProduzenjePozajmicaSearchObject search, IQueryable<ProduzenjePozajmica> query)
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

        public override async Task BeforeInsertAsync(ProduzenjePozajmicaInsertRequest request, ProduzenjePozajmica entity, CancellationToken cancellationToken = default)
        {
            if(request.Produzenje<1 || request.Produzenje > 365)
            {
                throw new UserException("Trajanje mora biti u vrijednosti od 1 do 365 dana!");
            }
            entity.DatumZahtjeva = DateTime.Now;
            var pozajmica = await Context.Pozajmices.FirstOrDefaultAsync(x => x.PozajmicaId == request.PozajmicaId);
            entity.NoviRok = pozajmica.PreporuceniDatumVracanja.AddDays(request.Produzenje);
        }

        public override async Task BeforeUpdateAsync(ProduzenjePozajmicaUpdateRequest request, ProduzenjePozajmica entity, CancellationToken cancellationToken = default)
        {
            var produzenje = await Context.ProduzenjePozajmicas.FindAsync(entity.ProduzenjePozajmiceId);
            if (produzenje == null)
                throw new UserException("Pogrešno produženje!");

            if (request.Odobreno == true)
            {
                var pozajmica = await Context.Pozajmices.FirstOrDefaultAsync(x => x.PozajmicaId == produzenje.PozajmicaId);
                if (pozajmica != null)
                {
                    var pocetniDatum = pozajmica.PreporuceniDatumVracanja;
                    pozajmica.PreporuceniDatumVracanja = pocetniDatum.AddDays(produzenje.Produzenje);
                    await Context.SaveChangesAsync();
                }
            }
        }
    }
}
