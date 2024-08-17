using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.CitalacKnjigaLogDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [Authorize]
    [ApiController]
    public class CitalacKnjigaLogsController : BaseCRUDControllerAsync<Model.CitalacKnjigaLogDTOs.CitalacKnjigaLog, CitalacKnjigaLogSearchObject, CitalacKnjigaLogUpsertRequest, CitalacKnjigaLogUpsertRequest>
    {
        public CitalacKnjigaLogsController(ICitalacKnjigaLogService service) : base(service)
        {
        }
    }
}
