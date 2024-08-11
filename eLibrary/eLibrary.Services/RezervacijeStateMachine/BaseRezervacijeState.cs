using eLibrary.Model.Exceptions;
using eLibrary.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

namespace eLibrary.Services.RezervacijeStateMachine
{
    public class BaseRezervacijeState
    {
        private readonly IServiceProvider service;

        public ELibraryContext Context { get; }
        public IMapper Mapper { get; }

        public BaseRezervacijeState(ELibraryContext context, IMapper mapper, IServiceProvider service) 
        {
            Context = context;
            Mapper = mapper;
            this.service = service;
        }
        public async virtual Task<Model.RezervacijeDTOs.Rezervacije> Insert(Model.Requests.RezervacijeInsertRequest request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }

        public async virtual Task<Model.RezervacijeDTOs.Rezervacije> Ponisti(Database.Rezervacije request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }

        public async virtual Task<Model.RezervacijeDTOs.Rezervacije> Odobri(Database.Rezervacije request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }

        public async virtual Task<Model.RezervacijeDTOs.Rezervacije> Obnovi(Database.Rezervacije request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }

        public async virtual Task<Model.RezervacijeDTOs.Rezervacije> Zavrsi(Database.Rezervacije request)
        {
            throw new UserException("Metoda nije dozvoljena");
        }

        public virtual List<string> AllowedActions(Database.Rezervacije entity)
        {
            throw new UserException("Metoda nije dozvoljena");
        }


        public BaseRezervacijeState CreateState(string stateName)
        {
            switch(stateName)
            {
                case "Initial":
                    return service.GetService<InitialRezervacijaState>();
                case "Kreirana":
                    return service.GetService<KreiranaRezervacijaState>();
                case "Odobrena":
                    return service.GetService<OdobrenaRezervacijaState>();
                case "Ponistena":
                    return service.GetService<PonistenaRezervacijaState>();
                case "Obnovljena":
                    return service.GetService<ObnovljenaRezervacijaState>();
                case "Zavrsena":
                    return service.GetService<ZavrsenaRezervacijaState>();
                default: throw new Exception("State ne postoji");
            }
        }
    }
}
