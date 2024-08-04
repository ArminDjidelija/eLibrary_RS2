using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.PenaliDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class PenaliController : BaseCRUDControllerAsync<Model.PenaliDTOs.Penali, PenaliSearchObject, PenaliInsertRequest, PenaliUpdateRequest>
    {
        public PenaliController(IPenaliService service) : base(service)
        {
        }

        [HttpGet("biblioteka")]
        public async Task<Model.BibliotekeDTOs.Biblioteke> GetBiblioteka(int penalId, CancellationToken cancellationToken = default)
        {
            return await (_service as IPenaliService).GetBibliotekaByPenalAsync(penalId, cancellationToken);
        }
    }
}
