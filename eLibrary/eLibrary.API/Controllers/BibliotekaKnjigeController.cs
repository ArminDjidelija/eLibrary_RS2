﻿using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.BibliotekaKnjigeDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class BibliotekaKnjigeController : BaseCRUDControllerAsync<Model.BibliotekaKnjigeDTOs.BibliotekaKnjige, BibliotekaKnjigeSearchObject, BibliotekaKnjigeInsertRequest, BibliotekaKnjigeUpdateRequest>
    {
        public BibliotekaKnjigeController(IBibliotekaKnjigeService service) : base(service)
        {
        }
    }
}