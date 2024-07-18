using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class TipClanarineBibliotekeSearchObject:BaseSearchObject
    {
        public int? TrajanjeGTE { get; set; }
        public int? TrajanjeLTE { get; set; }

        public decimal? IznosGTE { get; set; }
        public decimal? IznosLTE { get; set; }

        public int? BibliotekaId { get; set; }
    }
}
