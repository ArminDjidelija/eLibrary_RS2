using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class ObavijestiInsertRequest
    {
        public int? BibliotekaId { get; set; }

        public string Naslov { get; set; }

        public string Tekst { get; set; }

        public int? CitalacId { get; set; }
    }
}
