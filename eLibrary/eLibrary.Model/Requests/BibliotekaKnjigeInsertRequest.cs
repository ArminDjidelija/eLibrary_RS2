using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class BibliotekaKnjigeInsertRequest
    {
        public int BibliotekaId { get; set; }

        public int KnjigaId { get; set; }

        public int BrojKopija { get; set; }

        public string? Lokacija { get; set; }

        public int? DostupnoCitaonica { get; set; }

        public int? DostupnoPozajmica { get; set; }
    }
}
