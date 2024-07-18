using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Model.VrsteGradeDTOs;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class VrsteGradeController : BaseCRUDControllerAsync<Model.VrsteGradeDTOs.VrsteGrade, VrsteGradeSearchObject, VrsteGradeUpsertRequest, VrsteGradeUpsertRequest>
    {
        public VrsteGradeController(IVrsteGradeService service) : base(service)
        {
        }
    }
}
