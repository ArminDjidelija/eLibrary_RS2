using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class PozajmiceSearchObject:BaseSearchObject
    {
        public int? CitalacId { get; set; }

        public int? BibliotekaKnjigaId { get; set; }
    }
}
