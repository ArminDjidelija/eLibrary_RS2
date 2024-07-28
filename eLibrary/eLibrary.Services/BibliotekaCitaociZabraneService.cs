using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class BibliotekaCitaociZabraneService : BaseCRUDServiceAsync<Model.BibliotekaCitaociZabraneDTOs.BibliotekaCitaociZabrane, BibliotekaCitaociZabraneSearchObject, Database.BibliotekaCitaociZabrane, BibliotekaCitaociZabraneInsertRequest, BibliotekaCitaociZabraneUpdateRequest>, IBibliotekaCitaociZabraneService
    {
        public BibliotekaCitaociZabraneService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
