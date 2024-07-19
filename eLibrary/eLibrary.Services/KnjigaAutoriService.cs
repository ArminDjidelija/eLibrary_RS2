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
    public class KnjigaAutoriService : BaseCRUDServiceAsync<Model.KnjigaAutoriDTOs.KnjigaAutori, KnjigaAutoriSearchObject, Database.KnjigaAutori, KnjigaAutoriUpsertRequest, KnjigaAutoriUpsertRequest>, IKnjigaAutoriService
    {
        public KnjigaAutoriService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<KnjigaAutori> AddFilter(KnjigaAutoriSearchObject search, IQueryable<KnjigaAutori> query)
        {
            if (search.AutorId != null)
            {
                query=query.Where(x=>x.AutorId== search.AutorId);
            }
            if (search.KnjigaId != null)
            {
                query = query.Where(x => x.KnjigaId == search.KnjigaId);
            }
            return query;
        }
    }
}
