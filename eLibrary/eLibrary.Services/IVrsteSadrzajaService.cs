using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;

namespace eLibrary.Services
{
    public interface IVrsteSadrzajaService:ICRUDServiceAsync<Model.VrsteSadrzajaDTOs.VrsteSadrzaja, VrsteSadrzajaSearchObject, VrsteSadrzajaUpsertRequest, VrsteSadrzajaUpsertRequest>
    {
    }
}
