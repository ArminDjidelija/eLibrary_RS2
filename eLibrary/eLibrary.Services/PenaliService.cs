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
    public class PenaliService : BaseCRUDServiceAsync<Model.PenaliDTOs.Penali, PenaliSearchObject, Database.Penali, PenaliInsertRequest, PenaliUpdateRequest>,IPenaliService
    {
        public PenaliService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Penali> AddFilter(PenaliSearchObject search, IQueryable<Penali> query)
        {
            if(search?.CitalacId != null)
            {
                query = query
                   .Include(x => x.Pozajmica)
                   .Where(x => x.Pozajmica.CitalacId == search.CitalacId);
            }
            if (search?.BibliotekaId != null)
            {
                query = query
                    .Include(x => x.Pozajmica)
                    .ThenInclude(x => x.BibliotekaKnjiga)
                    .Where(x => x.Pozajmica.BibliotekaKnjiga.BibliotekaId == search.BibliotekaId);
            }
            return query;
        }



    }
}
