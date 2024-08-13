using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public interface ICitaociService:ICRUDServiceAsync<Model.CitaociDTOs.Citaoci, CitaociSearchObject, CitaociInsertRequest, CitaociUpdateRequest>
    {
        Model.CitaociDTOs.Citaoci Login(string username, string password);
        Task<List<Model.KnjigeDTOs.Knjige>> Recommend(int id);
    }
}
