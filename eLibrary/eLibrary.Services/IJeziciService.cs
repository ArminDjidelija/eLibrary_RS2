using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;

namespace eLibrary.Services
{
    public interface IJeziciService : ICRUDServiceAsync<Model.JeziciDTOs.Jezici, JeziciSearchObject, JeziciUpsertRequest, JeziciUpsertRequest>
    {

    }
}
