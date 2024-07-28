using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.BibliotekaUposleniDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class BibliotekaUposleniController : BaseCRUDControllerAsync<Model.BibliotekaUposleniDTOs.BibliotekaUposleni, BibliotekaUposleniSearchObject, BibliotekaUposleniInsertRequest, BibliotekaUposleniUpdateRequest>
    {
        public BibliotekaUposleniController(IBibliotekaUposleniService service) : base(service)
        {
        }
    }
}
