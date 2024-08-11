using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public interface IRezervacijeService:ICRUDServiceAsync<Model.RezervacijeDTOs.Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        Task<Model.RezervacijeDTOs.Rezervacije> OdobriAsync(int rezervacijaId, CancellationToken cancellationToken=default);
        Task<Model.RezervacijeDTOs.Rezervacije> PonistiAsync(int rezervacijaId, CancellationToken cancellationToken = default);
        Task<Model.RezervacijeDTOs.Rezervacije> ObnoviAsync(int rezervacijaId, CancellationToken cancellationToken = default);
        Task<Model.RezervacijeDTOs.Rezervacije> ZavrsiAsync(int rezervacijaId, CancellationToken cancellationToken = default);
        Task<List<string>> AllowedActions(int rezervacijaId, CancellationToken cancellationToken = default);
    }
}
