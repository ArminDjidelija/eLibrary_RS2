using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.RezervacijeDTOs;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class RezervacijeController : BaseCRUDControllerAsync<Model.RezervacijeDTOs.Rezervacije, RezervacijeSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        public RezervacijeController(IRezervacijeService service) : base(service)
        {
        }

        [HttpPut("{id}/odobri")]
        public Task<Model.RezervacijeDTOs.Rezervacije> Odobri(int id, CancellationToken cancellationToken=default)
        {
            return (_service as IRezervacijeService).OdobriAsync(id, cancellationToken);
        }

        [HttpPut("{id}/ponisti")]
        public Task<Model.RezervacijeDTOs.Rezervacije> Ponisti(int id, CancellationToken cancellationToken = default)
        {
            return (_service as IRezervacijeService).PonistiAsync(id, cancellationToken);
        }

        [HttpPut("{id}/obnovi")]
        public Task<Model.RezervacijeDTOs.Rezervacije> Obnovi(int id, CancellationToken cancellationToken = default)
        {
            return (_service as IRezervacijeService).ObnoviAsync(id, cancellationToken);
        }

        [HttpPut("{id}/zavrsi")]
        public Task<Model.RezervacijeDTOs.Rezervacije> Zavrsi(int id, CancellationToken cancellationToken = default)
        {
            return (_service as IRezervacijeService).ZavrsiAsync(id, cancellationToken);
        }

        [HttpGet("{id}/allowedActions")]
        public Task<List<string>> AllowedActions(int id, CancellationToken cancellationToken = default)
        {
            return (_service as IRezervacijeService).AllowedActions(id, cancellationToken);
        }
    }
}
