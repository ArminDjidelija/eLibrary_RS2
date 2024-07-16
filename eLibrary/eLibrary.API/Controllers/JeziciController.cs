﻿using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
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
    }
}