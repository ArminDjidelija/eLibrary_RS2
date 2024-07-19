using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class BibliotekaKnjigeUpdateRequest
    {
        public int BrojKopija { get; set; }

        public string? Lokacija { get; set; }

        public int? DostupnoCitaonica { get; set; }

        public int? DostupnoPozajmica { get; set; }
    }
}
