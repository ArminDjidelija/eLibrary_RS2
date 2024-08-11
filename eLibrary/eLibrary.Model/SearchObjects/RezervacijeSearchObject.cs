using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class RezervacijeSearchObject:BaseSearchObject
    {
        public int? CitalacId { get; set; }

        public int? BibliotekaKnjigaId { get; set; }

        public int? BibliotekaId { get; set; }

        public DateTime? DatumKreiranjaGTE { get; set; }
        public DateTime? DatumKreiranjaLTE { get; set; }

        public bool? Odobreno { get; set; }

        public DateTime? RokRezervacijeLTE { get; set; }

        public bool? Ponistena { get; set; }

        public string? ImePrezimeGTE { get; set; }

        public bool? Aktivna {  get; set; }
        public string? NaslovGTE { get; set; }
    }
}
