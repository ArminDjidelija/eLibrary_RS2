using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;

namespace eLibrary.Services
{
    public interface IKorisniciService:ICRUDServiceAsync<Model.KorisniciDTOs.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        Model.KorisniciDTOs.Korisnici Login(string username, string password);
        Task<Model.KorisniciDTOs.Korisnici> GetInfo(CancellationToken cancellationToken = default);
    }
}
