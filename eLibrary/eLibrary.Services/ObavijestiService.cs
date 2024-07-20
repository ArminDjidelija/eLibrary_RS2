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
    public class ObavijestiService : BaseCRUDServiceAsync<Model.ObavijestiDTOs.Obavijesti, ObavijestiSearchObject, Database.Obavijesti, ObavijestiInsertRequest, ObavijestiUpdateRequest>,IObavijestiService
    {
        public ObavijestiService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Obavijesti> AddFilter(ObavijestiSearchObject search, IQueryable<Obavijesti> query)
        {
            if (search?.BibliotekaId != null && search?.CitalacId!=null)
            {
                return query;
            }

            if (search?.BibliotekaId != null)
            {
                query=query.Where(x=>x.ObavijestId==search.BibliotekaId);
            }
            if(search?.CitalacId != null)
            {
                query=query.Where(x=>x.CitalacId==search.CitalacId);
            }

            return query;
        }

        public override async Task BeforeInsertAsync(ObavijestiInsertRequest request, Obavijesti entity, CancellationToken cancellationToken = default)
        {
            entity.Datum = DateTime.Now;
        }

        public override async Task BeforeUpdateAsync(ObavijestiUpdateRequest request, Obavijesti entity, CancellationToken cancellationToken = default)
        {
            entity.Datum = DateTime.Now;
        }
    }
}
