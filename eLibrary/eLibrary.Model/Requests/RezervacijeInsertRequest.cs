using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class RezervacijeInsertRequest
    {
        public int CitalacId { get; set; }

        public int BibliotekaKnjigaId { get; set; }
    }
}
