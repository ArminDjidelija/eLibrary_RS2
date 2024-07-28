using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServicesInterfaces;

namespace eLibrary.Services
{
    public interface IUlogeService:IServiceAsync<Model.UlogeDTOs.Uloge, UlogeSearchObject>
    {
    }
}
