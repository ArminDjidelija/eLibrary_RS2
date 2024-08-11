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
    public class PonistenaRezervacijaState : BaseRezervacijeState
    {

        public PonistenaRezervacijaState(ELibraryContext context, IMapper mapper, IServiceProvider service) 
            : base(context, mapper, service)
        {
        }
        public override async Task<Model.RezervacijeDTOs.Rezervacije> Obnovi(Database.Rezervacije request)
        {
            request.Ponistena = false;
            request.Odobreno = true;
            request.RokRezervacije = DateTime.Now.AddDays(1);
            request.State = "Obnovljena";

            await Context.SaveChangesAsync();

            return Mapper.Map<Model.RezervacijeDTOs.Rezervacije>(request);
        }

        public override List<string> AllowedActions(Database.Rezervacije entity)
        {
            return new List<string>() { nameof(Obnovi) };
        }
    }
}
