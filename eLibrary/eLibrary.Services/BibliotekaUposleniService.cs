using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;

namespace eLibrary.Services
{
    public class BibliotekaUposleniService : BaseCRUDServiceAsync<Model.BibliotekaUposleniDTOs.BibliotekaUposleni, BibliotekaUposleniSearchObject, Database.BibliotekaUposleni, BibliotekaUposleniInsertRequest, BibliotekaUposleniUpdateRequest>, IBibliotekaUposleniService
    {
        public BibliotekaUposleniService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<BibliotekaUposleni> AddFilter(BibliotekaUposleniSearchObject search, IQueryable<BibliotekaUposleni> query)
        {
            if (search?.KorisnikId != null)
            {
                query=query.Where(x=>x.KorisnikId==search.KorisnikId);
            }
            if(search?.BibliotekaId != null)
            {
                query=query.Where(x=>x.BibliotekaId==search.BibliotekaId);
            }
            return query;
        }
    }
}
