using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    public class BibliotekeController : BaseCRUDControllerAsync<Model.BibliotekeDTOs.Biblioteke, BibliotekeSearchObject, BibliotekeUpsertRequest, BibliotekeUpsertRequest>
    {
        public BibliotekeController(IBibliotekeService service) : base(service)
        {
        }
    }
}
