using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.GeneralDTOs
{
    public class ObavijestiDTO
    {
        public int ObavijestId { get; set; }

        public int? BibliotekaId { get; set; }

        public string Naslov { get; set; } 

        public string Tekst { get; set; } 

        public DateTime Datum { get; set; }

        public int? CitalacId { get; set; }
    }
}
