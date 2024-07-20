using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class BibliotekaKnjigeSearchObject:BaseSearchObject
    {
        public int? BibliotekaId { get; set; }

        public int? KnjigaId { get; set; }

        public int? BrojKopijaGTE { get; set; }

        public string? Isbn { get; set; }

        public DateTime? DatumDodavanjaGTE { get; set; }
        public DateTime? DatumDodavanjaLTE { get; set; }
    }
}
