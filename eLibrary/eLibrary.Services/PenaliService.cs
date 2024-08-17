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
    public class PenaliService : BaseCRUDServiceAsync<Model.PenaliDTOs.Penali, PenaliSearchObject, Database.Penali, PenaliInsertRequest, PenaliUpdateRequest>, IPenaliService
    {
        public PenaliService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Penali> AddFilter(PenaliSearchObject search, IQueryable<Penali> query)
        {
            if(search?.PozajmicaId != null)
            {
                query=query.Where(x=> x.PozajmicaId == search.PozajmicaId);   
            }
            if(search?.CitalacId != null)
            {
                query = query
                   .Include(x => x.Pozajmica)
                   .Where(x => x.Pozajmica.CitalacId == search.CitalacId);
            }
            if (search?.BibliotekaId != null)
            {
                query = query
                    .Include(x => x.Pozajmica)
                    .ThenInclude(x => x.BibliotekaKnjiga)
                    .Where(x => x.Pozajmica.BibliotekaKnjiga.BibliotekaId == search.BibliotekaId);
            }
            if (search?.Placeno != null)
            {
                if(search.Placeno==true)
                {
                    query = query.Where(x => x.UplataId != null);
                }
                else
                {
                    query = query.Where(x => x.UplataId == null);
                }
            }
            return query;
        }

        public async Task<Model.BibliotekeDTOs.Biblioteke> GetBibliotekaByPenalAsync(int penalId, CancellationToken cancellationToken = default)
        {
            var penal=await Context
                .Penalis
                .Include(x=>x.Pozajmica)
                .ThenInclude(x=>x.BibliotekaKnjiga)
                .ThenInclude(x=>x.Biblioteka)
                .Where(x=>x.PenalId==penalId).FirstOrDefaultAsync(cancellationToken);
            if (penal == null)
                throw new UserException("Pogrešan penal ID");
            var biblioteka = penal.Pozajmica.BibliotekaKnjiga.Biblioteka;

            return Mapper.Map<Model.BibliotekeDTOs.Biblioteke>(biblioteka);
        }

        public async Task<Model.PenaliDTOs.Penali> Plati(int penalId, int tipUplateId, CancellationToken cancellationToken = default)
        {
            var penal = await Context.Penalis.FindAsync(penalId);
            if (penal == null)
                throw new UserException("Penal ne postoji!");
            var biblioteka = await GetBibliotekaByPenalAsync(penalId, cancellationToken);

            var citalacId = await Context
                .Penalis
                .Include(x=> x.Pozajmica)
                .Where(x=>x.PenalId==penalId)
                .Select(x=>x.Pozajmica.CitalacId)
                .FirstOrDefaultAsync(cancellationToken);

            var uplata = new Database.Uplate
            {
                BibliotekaId = biblioteka.BibliotekaId,
                TipUplateId = tipUplateId,
                CitalacId = citalacId,
                DatumUplate = DateTime.Now,
                Iznos = penal.Iznos,
                ValutaId = penal.ValutaId.Value
            };
            await Context.Uplates.AddAsync(uplata);
            await Context.SaveChangesAsync(cancellationToken);

            penal.UplataId = uplata.UplataId;
            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<Model.PenaliDTOs.Penali>(penal);
        }
    }
}
