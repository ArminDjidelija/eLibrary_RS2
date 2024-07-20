using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class PozajmiceInsertRequest
    {
        public int CitalacId { get; set; }

        public int BibliotekaKnjigaId { get; set; }

        public DateTime DatumPreuzimanja { get; set; }

        public int Trajanje { get; set; }

        public bool MoguceProduziti { get; set; }
    }
}
