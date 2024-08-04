using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.ClanarineDTOs
{
    public class Uplate_ClanarineDTO
    {
        public int UplataId { get; set; }

        public int CitalacId { get; set; }

        public int BibliotekaId { get; set; }

        public decimal Iznos { get; set; }

        public DateTime DatumUplate { get; set; }

        public int TipUplateId { get; set; }

        public int ValutaId { get; set; }

        public ValuteDTOs.Valute Valuta { get; set; }
    }
}
