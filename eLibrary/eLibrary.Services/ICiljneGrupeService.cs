using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;

namespace eLibrary.Services
{
    public interface ICiljneGrupeService : ICRUDServiceAsync<Model.CiljneGrupeDTOs.CiljneGrupe, CiljnaGrupaSearchObject, CiljnaGrupaUpsertRequest, CiljnaGrupaUpsertRequest>
    {
    }
}
