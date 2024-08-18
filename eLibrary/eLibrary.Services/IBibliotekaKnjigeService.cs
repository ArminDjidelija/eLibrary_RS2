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
    public interface IBibliotekaKnjigeService:ICRUDServiceAsync<Model.BibliotekaKnjigeDTOs.BibliotekaKnjige, BibliotekaKnjigeSearchObject, BibliotekaKnjigeInsertRequest, BibliotekaKnjigeUpdateRequest>
    {
        Task<List<Model.BibliotekaKnjigeDTOs.PozajmicaInfo>> GenerateReportData(int bibliotekaKnjigaId, CancellationToken cancellationToken = default);
    }
}
