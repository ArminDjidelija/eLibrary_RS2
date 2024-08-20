using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;

namespace eLibrary.Services
{
    public interface IPozajmiceService:ICRUDServiceAsync<Model.PozajmiceDTOs.Pozajmice, PozajmiceSearchObject, PozajmiceInsertRequest, PozajmiceUpdateRequest>
    {
        Task<Model.PozajmiceDTOs.Pozajmice> PotvrdiVracanje(int pozajmicaId, CancellationToken cancellationToken=default);
        Task ObavijestiORoku(int pozajmicaId, CancellationToken cancellationToken = default);
    }
}
