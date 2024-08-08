using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;

namespace eLibrary.Services
{
    public class TipClanarineBibliotekeService : BaseCRUDServiceAsync<Model.TipClanarineBibliotekeDTOs.TipClanarineBiblioteke, TipClanarineBibliotekeSearchObject, Database.TipClanarineBiblioteke, TipClanarineBibliotekeInsertRequest, TipClanarineBibliotekeUpdateRequest>, ITipClanarineBibliotekeService
    {
        private readonly ICurrentUserServiceAsync currentUserService;

        public TipClanarineBibliotekeService(Database.ELibraryContext context, IMapper mapper, ICurrentUserServiceAsync currentUserService) : base(context, mapper)
        {
            this.currentUserService = currentUserService;
        }

        public override IQueryable<TipClanarineBiblioteke> AddFilter(TipClanarineBibliotekeSearchObject search, IQueryable<TipClanarineBiblioteke> query)
        {
            if(search?.BibliotekaId != null)
            {
                query=query.Where(x=>x.BibliotekaId==search.BibliotekaId);
            }

            if(search?.IznosGTE != null)
            {
                query = query.Where(x => x.Iznos > search.IznosGTE);
            }
            if (search?.IznosLTE != null)
            {
                query = query.Where(x => x.Iznos < search.IznosLTE);
            }
            if (search?.TrajanjeGTE != null)
            {
                query = query.Where(x => x.Trajanje > search.TrajanjeGTE);
            }
            if (search?.TrajanjeLTE != null)
            {
                query = query.Where(x => x.Trajanje > search.TrajanjeLTE);
            }
            return query;
        }

        public override async Task BeforeInsertAsync(TipClanarineBibliotekeInsertRequest request, TipClanarineBiblioteke entity, CancellationToken cancellationToken = default)
        {
            var bibliotekaId = await currentUserService.GetBibliotekaIdFromUserAsync();
            entity.BibliotekaId=bibliotekaId;
        }
    }
}
