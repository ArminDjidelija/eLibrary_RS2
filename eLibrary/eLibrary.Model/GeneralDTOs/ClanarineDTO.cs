using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.GeneralDTOs
{
    public class ClanarineDTO
    {
        public int ClanarinaId { get; set; }

        public int CitalacId { get; set; }

        public int BibliotekaId { get; set; }

        public int UplateId { get; set; }

        public int TipClanarineBibliotekaId { get; set; }

        public decimal Iznos { get; set; }

        public DateTime Pocetak { get; set; }

        public DateTime Kraj { get; set; }
    }
}
