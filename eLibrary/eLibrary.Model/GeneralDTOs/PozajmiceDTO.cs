using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.GeneralDTOs
{
    public class PozajmiceDTO
    {
        public int PozajmicaId { get; set; }

        public int CitalacId { get; set; }

        public int BibliotekaKnjigaId { get; set; }

        public DateTime DatumPreuzimanja { get; set; }

        public DateTime PreporuceniDatumVracanja { get; set; }

        public DateTime? StvarniDatumVracanja { get; set; }

        public int Trajanje { get; set; }

        public bool MoguceProduziti { get; set; }
    }
}
