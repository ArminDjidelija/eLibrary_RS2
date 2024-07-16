using eLibrary.Model;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class JeziciController : BaseCRUDController<Model.Jezici, JeziciSearchObject, JeziciUpsertRequest, JeziciUpsertRequest>
    {
        public JeziciController(IJeziciService service) : base(service)
        {
        }

        public override Jezici Insert(JeziciUpsertRequest request)
        {
            return base.Insert(request);
        }

        public override PagedResult<Jezici> GetList([FromQuery] JeziciSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }

    }
}
