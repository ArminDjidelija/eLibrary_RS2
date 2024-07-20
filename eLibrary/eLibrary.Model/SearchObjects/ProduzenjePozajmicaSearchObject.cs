using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class ProduzenjePozajmicaSearchObject:BaseSearchObject
    {
        public bool? Odobreno { get; set; }

        public int? PozajmicaId { get; set; }
    }
}
