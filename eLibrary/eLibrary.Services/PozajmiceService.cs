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
    public class PozajmiceService : BaseCRUDServiceAsync<Model.PozajmiceDTOs.Pozajmice, PozajmiceSearchObject, Database.Pozajmice, PozajmiceInsertRequest, PozajmiceUpdateRequest>, IPozajmiceService
    {
        public PozajmiceService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Pozajmice> AddFilter(PozajmiceSearchObject search, IQueryable<Pozajmice> query)
        {
            if (search?.CitalacId != null)
            {
                query=query.Where(x=>x.CitalacId==search.CitalacId);
            }
            if (search?.BibliotekaKnjigaId != null)
            {
                query = query.Where(x => x.BibliotekaKnjigaId == search.BibliotekaKnjigaId);
            }
            return query;
        }

        public override async Task BeforeInsertAsync(PozajmiceInsertRequest request, Pozajmice entity, CancellationToken cancellationToken = default)
        {
            if (request.Trajanje <= 0)
            {
                throw new UserException("Trajanje mora biti minimalno 1 dan!");
            }
            if (request.Trajanje > 365)
            {
                throw new UserException("Pozajmica ne može biti veća od jedne godine dana!");
            }
            entity.DatumPreuzimanja=DateTime.Now;
            entity.PreporuceniDatumVracanja = DateTime.Now.AddDays(request.Trajanje);
        }
    }
}
