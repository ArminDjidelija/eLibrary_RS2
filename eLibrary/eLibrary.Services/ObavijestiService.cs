using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
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
        private readonly ICurrentUserServiceAsync currentUserService;

        public ObavijestiService(ELibraryContext context, IMapper mapper, ICurrentUserServiceAsync currentUserService) : base(context, mapper)
        {
            this.currentUserService = currentUserService;
        }

        public override IQueryable<Obavijesti> AddFilter(ObavijestiSearchObject search, IQueryable<Obavijesti> query)
        {
            if (search?.NaslovGTE!=null)
            {
                query = query
                    .Where(x => x.Naslov.ToLower().StartsWith(search.NaslovGTE.ToLower()));
            }

            if (search?.BibliotekaId != null)
            {
                query=query.Where(x=>x.BibliotekaId==search.BibliotekaId);
            }
            if(search?.CitalacId != null)
            {
                query=query.Where(x=>x.CitalacId==search.CitalacId);
            }

            if (search?.GeneralnaObavijest != null)
            {
                if (search.GeneralnaObavijest == true)
                {
                    query = query
                        .Where(x => x.CitalacId == null);
                }
                else
                {
                    query = query
                        .Where(x => x.CitalacId != null);
                }
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
