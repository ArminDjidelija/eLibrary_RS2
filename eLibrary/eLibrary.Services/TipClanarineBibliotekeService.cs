using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using MapsterMapper;

namespace eLibrary.Services
{
    public class TipClanarineBibliotekeService : BaseCRUDServiceAsync<Model.TipClanarineBibliotekeDTOs.TipClanarineBiblioteke, TipClanarineBibliotekeSearchObject, Database.TipClanarineBiblioteke, TipClanarineBibliotekeInsertRequest, TipClanarineBibliotekeUpdateRequest>, ITipClanarineBibliotekeService
    {
        public TipClanarineBibliotekeService(Database.ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
