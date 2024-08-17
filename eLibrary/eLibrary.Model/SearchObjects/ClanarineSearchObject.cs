using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class ClanarineSearchObject:BaseSearchObject
    {
        public int? CitalacId { get; set; }
        public int? BibliotekaId { get; set; }
        public int? TipClanarineBibliotekaId { get; set; }

        public DateTime? PocetakGTE { get; set; }
        public DateTime? PocetakLTE { get; set; }

        public DateTime? KrajGTE { get; set; }
        public DateTime? KrajLTE { get; set; }

        public string? ImePrezimeGTE { get; set; }
        public string? EmailGTE { get; set; }
    }
}
