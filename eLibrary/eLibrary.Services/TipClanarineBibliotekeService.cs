using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;

namespace eLibrary.Services
{
    public class TipClanarineBibliotekeService : BaseCRUDServiceAsync<Model.TipClanarineBibliotekeDTOs.TipClanarineBiblioteke, TipClanarineBibliotekeSearchObject, Database.TipClanarineBiblioteke, TipClanarineBibliotekeInsertRequest, TipClanarineBibliotekeUpdateRequest>, ITipClanarineBibliotekeService
    {
        public TipClanarineBibliotekeService(Database.ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
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
    }
}
