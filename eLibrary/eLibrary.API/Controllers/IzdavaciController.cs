﻿using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.Izdavaci;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class IzdavaciController : BaseCRUDControllerAsync<Model.Izdavaci.Izdavaci, IzdavaciSearchObject, IzdavaciUpsertRequest, IzdavaciUpsertRequest>
    {
        public IzdavaciController(IIzdavaciService service) : base(service)
        {
        }
    }
}
