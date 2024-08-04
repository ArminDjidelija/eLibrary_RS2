using eLibrary.Model.BibliotekeDTOs;
using eLibrary.Model.CitaociDTOs;
using eLibrary.Model.TipClanarineBibliotekeDTOs;
using eLibrary.Model.UplateDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.ClanarineDTOs
{
    public class Clanarine
    {
        public int ClanarinaId { get; set; }

        public int CitalacId { get; set; }

        public int BibliotekaId { get; set; }

        public int UplateId { get; set; }

        public int TipClanarineBibliotekaId { get; set; }

        public decimal Iznos { get; set; }

        public DateTime Pocetak { get; set; }

        public DateTime Kraj { get; set; }

        public virtual Biblioteke? Biblioteka { get; set; } 

        public virtual GeneralDTOs.CitaociDTO? Citalac { get; set; } 

        public virtual GeneralDTOs.TipClanarineBibliotekeDTO? TipClanarineBiblioteka { get; set; } 

        public virtual Uplate_ClanarineDTO Uplate { get; set; } 
    }
}
