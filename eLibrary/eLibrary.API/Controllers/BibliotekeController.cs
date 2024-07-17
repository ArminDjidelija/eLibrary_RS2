using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.BibliotekeDTO;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;

namespace eLibrary.API.Controllers
{
    public class BibliotekeController : BaseCRUDControllerAsync<Model.BibliotekeDTO.Biblioteke, BibliotekeSearchObject, BibliotekeUpsertRequest, BibliotekeUpsertRequest>
    {
        public BibliotekeController(IBibliotekeService service) : base(service)
        {
        }
    }
}
