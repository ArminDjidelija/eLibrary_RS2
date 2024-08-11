using eLibrary.Model.BibliotekaKnjigeDTOs;
using eLibrary.Model.CitaociDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.RezervacijeDTOs
{
    public class Rezervacije
    {
        public int RezervacijaId { get; set; }

        public int CitalacId { get; set; }

        public int BibliotekaKnjigaId { get; set; }

        public DateTime DatumKreiranja { get; set; }

        public bool? Odobreno { get; set; }

        public DateTime? RokRezervacije { get; set; }

        public bool? Ponistena { get; set; }

        public string? State { get; set; }

        public virtual BibliotekaKnjige BibliotekaKnjiga { get; set; }

        public virtual GeneralDTOs.CitaociDTO Citalac { get; set; }
    }
}
