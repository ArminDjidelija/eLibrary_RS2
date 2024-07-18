using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KnjigeDTOs
{
    public class BibliotekaKnjigeDTO
    {
        public int BibliotekaKnjigaId { get; set; }

        public int BibliotekaId { get; set; }

        public int KnjigaId { get; set; }

        public int BrojKopija { get; set; }

        public DateTime DatumDodavanja { get; set; }

        public string? Lokacija { get; set; }

        public int? DostupnoCitaonica { get; set; }

        public int? DostupnoPozajmica { get; set; }
    }
}
