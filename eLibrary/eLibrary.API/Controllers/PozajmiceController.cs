using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.PozajmiceDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class PozajmiceController : BaseCRUDControllerAsync<Model.PozajmiceDTOs.Pozajmice, PozajmiceSearchObject, PozajmiceInsertRequest, PozajmiceUpdateRequest>
    {
        public PozajmiceController(IPozajmiceService service) : base(service)
        {
        }

        [HttpPost("potvrdi")]
        public async Task<Model.PozajmiceDTOs.Pozajmice> Potvrdi(int id, CancellationToken cancellationToken = default)
        {
            return await (_service as IPozajmiceService).PotvrdiVracanje(id, cancellationToken);
        }

        [HttpPost("{id}/obavijesti")]
        public async Task Obavijesti(int id, CancellationToken cancellationToken = default)
        {
            await (_service as IPozajmiceService).ObavijestiORoku(id, cancellationToken);
        }

    }
}
