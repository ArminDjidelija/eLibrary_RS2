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
    public interface IPenaliService:ICRUDServiceAsync<Model.PenaliDTOs.Penali, PenaliSearchObject, PenaliInsertRequest, PenaliUpdateRequest>
    {
        Task<Model.BibliotekeDTOs.Biblioteke> GetBibliotekaByPenalAsync(int penalId, CancellationToken cancellationToken=default);
        Task<Model.PenaliDTOs.Penali> Plati(int penalId, int tipUplateId, CancellationToken cancellationToken = default);
    }
}
