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
    public class ZavrsenaRezervacijaState : BaseRezervacijeState
    {

        public ZavrsenaRezervacijaState(ELibraryContext context, IMapper mapper, IServiceProvider service) 
            : base(context, mapper, service)
        {
        }   

        public override List<string> AllowedActions(Database.Rezervacije entity)
        {
            return new List<string>() {};
        }
    }
}
