using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.GeneralDTOs
{
    public class BibliotekaCitaociZabrane
    {
        public int BibliotekaCitaocZabranaId { get; set; }

        public DateTime RokZabrane { get; set; }

        public int BibliotekaId { get; set; }

        public int CitalacId { get; set; }
        public string? StateMachine { get; set; }
    }
}
