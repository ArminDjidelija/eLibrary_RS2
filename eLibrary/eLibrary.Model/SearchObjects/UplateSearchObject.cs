using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class UplateSearchObject:BaseSearchObject
    {
        public int? CitalacId { get; set; }

        public int? BibliotekaId { get; set; }

        public decimal? IznosGTE { get; set; }
        public decimal? IznosLTE { get; set; }

        public DateTime? DatumUplateGTE { get; set; }
        public DateTime? DatumUplateLTE { get; set; }

        public int? TipUplateId { get; set; }

        public int? ValutaId { get; set; }
    }
}
