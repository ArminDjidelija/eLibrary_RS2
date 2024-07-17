﻿using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.CiljneGrupeDTO;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class CiljneGrupeController : BaseCRUDControllerAsync<Model.CiljneGrupeDTO.CiljneGrupe, CiljnaGrupaSearchObject, CiljnaGrupaUpsertRequest, CiljnaGrupaUpsertRequest>
    {
        public CiljneGrupeController(ICiljneGrupeService service) : base(service)
        {
        }
    }
}
