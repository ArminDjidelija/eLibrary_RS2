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

        [HttpPost("odobri")]
        public async Task<Model.RezervacijeDTOs.Rezervacije> Odobri(int id, bool potvrda, CancellationToken cancellationToken=default)
        {
            return await (_service as IRezervacijeService).OdobriAsync(id, potvrda, cancellationToken);
        }

        [HttpPost("ponisti")]
        public async Task<Model.RezervacijeDTOs.Rezervacije> Ponisti(int id, CancellationToken cancellationToken = default)
        {
            return await (_service as IRezervacijeService).PonistiAsync(id, cancellationToken);
        }
    }
}
