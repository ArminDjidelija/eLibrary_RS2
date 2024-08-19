using eLibrary.Model.Exceptions;
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
    public class KorisnikSacuvaneKnjigeService : BaseCRUDServiceAsync<Model.KorisnikSacuvaneKnjigeDTOs.KorisnikSacuvaneKnjige, KorisnikSacuvanaKnjigaSearchObject, Database.KorisnikSacuvanaKnjiga, KorisnikSacuvanaKnjigaInsertRequest, KorisnikSacuvanaKnjigaUpdateRequest>, IKorisnikSacuvanaKnjigaService
    {
        public KorisnikSacuvaneKnjigeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<KorisnikSacuvanaKnjiga> AddFilter(KorisnikSacuvanaKnjigaSearchObject search, IQueryable<KorisnikSacuvanaKnjiga> query)
        {
            if(search?.CitalacId != null)
            {
                query=query.Where(x=>x.CitalacId.Equals(search.CitalacId));
            }
            if(search?.KnjigaId != null)
            {
                query=query.Where(x=>x.KnjigaId.Equals(search.KnjigaId));
            }
            return query;
        }

        public override async Task BeforeInsertAsync(KorisnikSacuvanaKnjigaInsertRequest request, KorisnikSacuvanaKnjiga entity, CancellationToken cancellationToken = default)
        {
            var bk = await Context
                .KorisnikSacuvanaKnjigas
                .FirstOrDefaultAsync(x=> x.CitalacId == entity.CitalacId && x.KnjigaId == entity.KnjigaId);
            if(bk != null)
            {
                throw new UserException("Već imate ovu knjigu!");
            }
        }
    }
}
