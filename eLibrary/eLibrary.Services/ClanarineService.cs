using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
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
    public class ClanarineService : BaseCRUDServiceAsync<Model.ClanarineDTOs.Clanarine, ClanarineSearchObject, Database.Clanarine, ClanarineInsertRequest, ClanarineUpdateRequest>, IClanarineService
    {
        private readonly ICurrentUserServiceAsync currentUserService;

        public ClanarineService(ELibraryContext context, IMapper mapper, ICurrentUserServiceAsync currentUserService) : base(context, mapper)
        {
            this.currentUserService = currentUserService;
        }

        public override IQueryable<Clanarine> AddFilter(ClanarineSearchObject search, IQueryable<Clanarine> query)
        {
            if (!string.IsNullOrEmpty(search?.ImePrezimeGTE))
            {
                query=query
                    .Include(x=>x.Citalac)
                    .Where(x => (x.Citalac.Ime + " " + x.Citalac.Prezime).ToLower().StartsWith(search.ImePrezimeGTE.ToLower()));
            }
            if (search?.BibliotekaId != null)
            {
                query=query.Where(x=>x.BibliotekaId==search.BibliotekaId);
            }
            if(search?.TipClanarineBibliotekaId!= null)
            {
                query = query.Where(x => x.TipClanarineBibliotekaId == search.TipClanarineBibliotekaId);
            }
            if(search?.CitalacId != null)
            {
                query=query.Where(x=>x.CitalacId==search.CitalacId);    
            }

            return query;
        }

        public override async Task BeforeInsertAsync(ClanarineInsertRequest request, Clanarine entity, CancellationToken cancellationToken = default)
        {
            var tipClanarine = await Context.TipClanarineBibliotekes.FindAsync(request.TipClanarineBibliotekaId);
            if(tipClanarine== null)
            {
                throw new UserException("Pogrešan tip članarine");
            }
            if (tipClanarine.BibliotekaId != request.BibliotekaId)
            {
                throw new UserException("Pogrešna biblioteka i tip članarine!");
            }

            var uplata = new Database.Uplate()
            {
                BibliotekaId = request.BibliotekaId,
                CitalacId = request.CitalacId,
                DatumUplate = DateTime.Now,
                Iznos = tipClanarine.Iznos,
                TipUplateId = request.TipUplateId,
                ValutaId = tipClanarine.ValutaId,
            };

            try
            {
                Context.Add(uplata);
            }
            catch (Exception)
            {

                throw new UserException("Greška sa kreiranjem uplate");
            }

            await Context.SaveChangesAsync();

            entity.UplateId=uplata.UplataId;
            entity.Pocetak = DateTime.Now;
            entity.Kraj = DateTime.Now.AddDays(tipClanarine.Trajanje);
            entity.Iznos = tipClanarine.Iznos;

        }
    }
}
