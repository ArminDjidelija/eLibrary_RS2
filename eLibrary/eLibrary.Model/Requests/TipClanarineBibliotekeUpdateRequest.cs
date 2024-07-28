using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class TipClanarineBibliotekeUpdateRequest
    {
        public string Naziv { get; set; } = null!;

        public int Trajanje { get; set; }

        public decimal Iznos { get; set; }

        public int BibliotekaId { get; set; }

        public int ValutaId { get; set; }
    }
}
