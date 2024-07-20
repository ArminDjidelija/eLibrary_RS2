using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class BibliotekaCitaociZabraneSearchObject:BaseSearchObject
    {
        public DateTime? RokZabraneGTE { get; set; }
        public DateTime? RokZabraneLTE { get; set; }

        public int? BibliotekaId { get; set; }

        public int? CitalacId { get; set; }
        //public string? StateMachine { get; set; }
    }
}
