using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;

namespace eLibrary.Services
{
    public interface ITipClanarineBibliotekeService:ICRUDServiceAsync<Model.TipClanarineBibliotekeDTOs.TipClanarineBiblioteke, TipClanarineBibliotekeSearchObject, TipClanarineBibliotekeInsertRequest, TipClanarineBibliotekeUpdateRequest>
    {
    }
}
