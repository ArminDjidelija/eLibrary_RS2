using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class BibliotekaCitaociZabraneInsertRequest
    {
        public int BibliotekaCitaocZabranaId { get; set; }

        public int Trajanje { get; set; }

        //public DateTime RokZabrane { get; set; }

        public int BibliotekaId { get; set; }

        public int CitalacId { get; set; }
    }
}
