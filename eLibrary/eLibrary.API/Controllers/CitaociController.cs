﻿using eLibrary.API.Controllers.BaseControllers;
using eLibrary.Model.CitaociDTOs;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services;
using eLibrary.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eLibrary.API.Controllers
{
    [ApiController]
    public class CitaociController : BaseCRUDControllerAsync<Model.CitaociDTOs.Citaoci, CitaociSearchObject, CitaociInsertRequest, CitaociUpdateRequest>
    {
        public CitaociController(ICitaociService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public Model.CitaociDTOs.Citaoci Login(string username, string password)
        {
            return (_service as ICitaociService).Login(username, password);
        }

        [AllowAnonymous]
        [HttpGet("recommended")]
        public Task<List<Model.KnjigeDTOs.Knjige>> Recommend(int citalacId)
        {
            return (_service as ICitaociService).Recommend(citalacId);
        }

        [AllowAnonymous]
        [HttpGet("traindata")]
        public void TrainData()
        {
            (_service as ICitaociService).TrainData();
        }

        [HttpGet("info")]
        public Task<Model.CitaociDTOs.Citaoci> GetInfo(CancellationToken cancellationToken = default)
        {
            return (_service as ICitaociService).GetInfo(cancellationToken);
        }
    }
}
