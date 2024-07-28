using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;

namespace eLibrary.Services
{
    public interface IIzdavaciService:ICRUDServiceAsync<Model.IzdavaciDTOs.Izdavaci, IzdavaciSearchObject, IzdavaciUpsertRequest, IzdavaciUpsertRequest>
    {
    }
}
