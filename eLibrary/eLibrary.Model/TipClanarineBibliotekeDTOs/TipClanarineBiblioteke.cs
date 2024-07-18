using eLibrary.Model.BibliotekeDTOs;
using eLibrary.Model.ValuteDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.TipClanarineBibliotekeDTOs
{
    public class TipClanarineBiblioteke
    {
        public int TipClanarineBibliotekaId { get; set; }

        public string Naziv { get; set; } = null!;

        public int Trajanje { get; set; }

        public decimal Iznos { get; set; }

        public int BibliotekaId { get; set; }

        public int ValutaId { get; set; }

        public virtual GeneralDTOs.BibliotekeDTO Biblioteka { get; set; }

        public virtual ICollection<GeneralDTOs.ClanarineDTO> Clanarines { get; set; } = new List<GeneralDTOs.ClanarineDTO>();

        public virtual Valute Valuta { get; set; } 
    }
}
