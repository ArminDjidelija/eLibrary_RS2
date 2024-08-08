using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class PenaliInsertRequest
    {
        public int PozajmicaId { get; set; }

        public string Opis { get; set; } 

        public decimal Iznos { get; set; }

        public int? UplataId { get; set; }

        public int? ValutaId { get; set; }
    }
}
