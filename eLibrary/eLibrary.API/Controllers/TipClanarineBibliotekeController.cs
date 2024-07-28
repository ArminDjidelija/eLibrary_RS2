using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Model.TipClanarineBibliotekeDTOs;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class TipClanarineBibliotekeController : BaseCRUDControllerAsync<Model.TipClanarineBibliotekeDTOs.TipClanarineBiblioteke, TipClanarineBibliotekeSearchObject, TipClanarineBibliotekeInsertRequest, TipClanarineBibliotekeUpdateRequest>
    {
        public TipClanarineBibliotekeController(ITipClanarineBibliotekeService service) : base(service)
        {
        }
    }
}
