using eLibrary.Model.BibliotekeDTOs;
using eLibrary.Model.CitaociDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.BibliotekaCitaociZabraneDTOs
{
    public class BibliotekaCitaociZabrane
    {
        public int BibliotekaCitaocZabranaId { get; set; }

        public DateTime RokZabrane { get; set; }

        public int BibliotekaId { get; set; }

        public int CitalacId { get; set; }
        public string? StateMachine { get; set; }

        public virtual Biblioteke? Biblioteka { get; set; } 

        public virtual GeneralDTOs.CitaociDTO? Citalac { get; set; }
    }
}
