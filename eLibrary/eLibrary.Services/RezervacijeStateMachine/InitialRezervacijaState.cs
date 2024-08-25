using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.RezervacijeDTOs;
using eLibrary.Services.Auth;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eLibrary.Services.RezervacijeStateMachine
{
    public class InitialRezervacijaState : BaseRezervacijeState
    {

        public InitialRezervacijaState(ELibraryContext context, IMapper mapper, IServiceProvider service) 
            : base(context, mapper, service)
        {
        }
        public override async Task<Model.RezervacijeDTOs.Rezervacije> Insert(RezervacijeInsertRequest request)
        {
            var set = Context.Set<Database.Rezervacije>();
            var entity = Mapper.Map<Database.Rezervacije>(request);
            entity.State = "Kreirana";

            entity.DatumKreiranja = DateTime.Now;
            var bibliotekaKnjiga = await Context.BibliotekaKnjiges.FindAsync(request.BibliotekaKnjigaId);
            if (bibliotekaKnjiga == null)
                throw new UserException("Pogrešna biblioteka knjiga");
            var clanarina = await Context
                .Clanarines
                .Where(x => x.CitalacId == request.CitalacId &&
                    x.BibliotekaId == bibliotekaKnjiga.BibliotekaId &&
                    x.Kraj > DateTime.Now).FirstOrDefaultAsync();
            if (clanarina == null)
                throw new UserException("Nemate clanarinu u ovoj biblioteci!");

            var penal = await Context
                .Penalis
                .Include(x => x.Pozajmica)
                .ThenInclude(x => x.BibliotekaKnjiga)
                .Where(x => x.Pozajmica.CitalacId == request.CitalacId &&
                    x.Pozajmica.BibliotekaKnjiga.BibliotekaId == bibliotekaKnjiga.BibliotekaId &&
                    x.UplataId == null).FirstOrDefaultAsync();

            if (penal != null)
                throw new UserException("Imate neplacene penale u ovoj biblioteci!");

            set.Add(entity);
            await Context.SaveChangesAsync();

            return Mapper.Map<Model.RezervacijeDTOs.Rezervacije>(entity);
        }      

        public override List<string> AllowedActions(Database.Rezervacije entity)
        {
            return new List<string>() { nameof(Insert) };
        }
    }
}
