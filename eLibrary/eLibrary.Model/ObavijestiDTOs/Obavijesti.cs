using eLibrary.Model.BibliotekeDTOs;
using eLibrary.Model.CitaociDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.ObavijestiDTOs
{
    public class Obavijesti
    {
        public int ObavijestId { get; set; }

        public int? BibliotekaId { get; set; }

        public string Naslov { get; set; }

        public string Tekst { get; set; } 

        public DateTime Datum { get; set; }

        public int? CitalacId { get; set; }

        public virtual GeneralDTOs.BibliotekeDTO? Biblioteka { get; set; }

        public virtual GeneralDTOs.CitaociDTO? Citalac { get; set; }
    }
}
