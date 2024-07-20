using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.ProduzenjePozajmicaDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class ProduzenjePozajmicaController : BaseCRUDControllerAsync<Model.ProduzenjePozajmicaDTOs.ProduzenjePozajmica, ProduzenjePozajmicaSearchObject, ProduzenjePozajmicaInsertRequest, ProduzenjePozajmicaUpdateRequest>
    {
        public ProduzenjePozajmicaController(IProduzenjePozajmicaService service) : base(service)
        {
        }
    }
}
