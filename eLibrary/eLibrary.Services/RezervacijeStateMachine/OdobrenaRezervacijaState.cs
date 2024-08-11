using eLibrary.Model.Requests;
using eLibrary.Model.RezervacijeDTOs;
using eLibrary.Services.Auth;
using eLibrary.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.RezervacijeStateMachine
{
    public class OdobrenaRezervacijaState : BaseRezervacijeState
    {

        public OdobrenaRezervacijaState(ELibraryContext context, IMapper mapper, IServiceProvider service) 
            : base(context, mapper, service)
        {
        }
       
        public override async Task<Model.RezervacijeDTOs.Rezervacije> Ponisti(Database.Rezervacije request)
        {
            request.Ponistena = true;
            request.State = "Ponistena";

            await Context.SaveChangesAsync();

            return Mapper.Map<Model.RezervacijeDTOs.Rezervacije>(request);
        }

        public override async Task<Model.RezervacijeDTOs.Rezervacije> Zavrsi(Database.Rezervacije request)
        {
            request.Ponistena = true;
            request.State = "Zavrsena";

            await Context.SaveChangesAsync();

            return Mapper.Map<Model.RezervacijeDTOs.Rezervacije>(request);
        }

        public override List<string> AllowedActions(Database.Rezervacije entity)
        {
            return new List<string>() { nameof(Ponisti), nameof(Zavrsi) };
        }
    }
}
