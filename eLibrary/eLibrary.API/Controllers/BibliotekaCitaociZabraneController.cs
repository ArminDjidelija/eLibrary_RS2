using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.BibliotekaCitaociZabraneDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class BibliotekaCitaociZabraneController : BaseCRUDControllerAsync<Model.BibliotekaCitaociZabraneDTOs.BibliotekaCitaociZabrane, BibliotekaCitaociZabraneSearchObject, BibliotekaCitaociZabraneInsertRequest, BibliotekaCitaociZabraneUpdateRequest>
    {
        public BibliotekaCitaociZabraneController(IBibliotekaCitaociZabraneService service) : base(service)
        {
        }
    }
}
