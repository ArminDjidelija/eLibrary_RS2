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
    public interface IObavijestiService:ICRUDServiceAsync<Model.ObavijestiDTOs.Obavijesti, ObavijestiSearchObject, ObavijestiInsertRequest, ObavijestiUpdateRequest>
    {
    }
}
