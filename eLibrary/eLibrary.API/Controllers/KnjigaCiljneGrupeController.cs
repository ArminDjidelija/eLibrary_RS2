using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.KnjigaCiljneGrupeDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class KnjigaCiljneGrupeController : BaseCRUDControllerAsync<Model.KnjigaCiljneGrupeDTOs.KnjigaCiljneGrupe, KnjigaCiljneGrupeSearchObject, KnjigaCiljneGrupeInsertRequest, KnjigaCiljneGrupeUpdateRequest>
    {
        public KnjigaCiljneGrupeController(IKnjigaCiljneGrupeService service) : base(service)
        {
        }
    }
}
