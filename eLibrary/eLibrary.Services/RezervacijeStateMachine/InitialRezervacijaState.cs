using eLibrary.Model.Requests;
using eLibrary.Model.RezervacijeDTOs;
using eLibrary.Services.Auth;
using eLibrary.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
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
