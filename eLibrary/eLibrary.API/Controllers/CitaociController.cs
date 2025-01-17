using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class CitaociController : BaseCRUDControllerAsync<Model.CitaociDTOs.Citaoci, CitaociSearchObject, CitaociInsertRequest, CitaociUpdateRequest>
    {
        public CitaociController(ICitaociService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public Model.CitaociDTOs.Citaoci Login(string username, string password)
        {
            return (_service as ICitaociService).Login(username, password);
        }

        [HttpGet("recommended")]
        public Task<List<Model.KnjigeDTOs.Knjige>> Recommend(int citalacId)
        {
            return (_service as ICitaociService).Recommend(citalacId);
        }

        [HttpGet("info")]
        public Task<Model.CitaociDTOs.Citaoci> GetInfo(CancellationToken cancellationToken = default)
        {
            return (_service as ICitaociService).GetInfo(cancellationToken);
        }
    }
}
