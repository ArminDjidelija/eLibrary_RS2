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
    public class KorisnikSacuvaneKnjigeService : BaseCRUDServiceAsync<Model.KorisnikSacuvaneKnjigeDTOs.KorisnikSacuvaneKnjige, KorisnikSacuvanaKnjigaSearchObject, Database.KorisnikSacuvanaKnjiga, KorisnikSacuvanaKnjigaInsertRequest, KorisnikSacuvanaKnjigaUpdateRequest>, IKorisnikSacuvanaKnjigaService
    {
        public KorisnikSacuvaneKnjigeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
