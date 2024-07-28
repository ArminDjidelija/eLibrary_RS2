using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.GeneralDTOs
{
    public class RezervacijeDTO
    {
        public int RezervacijaId { get; set; }

        public int CitalacId { get; set; }

        public int BibliotekaKnjigaId { get; set; }

        public DateTime DatumKreiranja { get; set; }

        public bool? Odobreno { get; set; }

        public DateTime? RokRezervacije { get; set; }

        public bool? Ponistena { get; set; }
    }
}
