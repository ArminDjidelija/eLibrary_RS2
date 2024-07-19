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
    public class BibliotekaKnjigeService : BaseCRUDServiceAsync<Model.BibliotekaKnjigeDTOs.BibliotekaKnjige, BibliotekaKnjigeSearchObject, Database.BibliotekaKnjige, BibliotekaKnjigeInsertRequest, BibliotekaKnjigeUpdateRequest>, IBibliotekaKnjigeService
    {
        public BibliotekaKnjigeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<BibliotekaKnjige> AddFilter(BibliotekaKnjigeSearchObject search, IQueryable<BibliotekaKnjige> query)
        {
            if (search?.BibliotekaId != null)
            {
                query=query.Where(x=>x.BibliotekaId==search.BibliotekaId);
            }
            if(search?.KnjigaId != null)
            {
                query=query.Where(x=>x.KnjigaId==search.KnjigaId);
            }
            if (search?.BrojKopijaGTE != null)
            {
                query = query.Where(x => x.BrojKopija > search.BrojKopijaGTE);
            }
            if(search?.DatumDodavanjaGTE != null)
            {
                query = query.Where(x => x.DatumDodavanja > search.DatumDodavanjaGTE);
            }
            if (search?.DatumDodavanjaLTE != null)
            {
                query = query.Where(x => x.DatumDodavanja < search.DatumDodavanjaLTE);
            }
            return query;
        }
    }
}
