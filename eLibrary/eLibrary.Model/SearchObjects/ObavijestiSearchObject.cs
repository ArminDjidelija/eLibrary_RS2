using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class ObavijestiSearchObject:BaseSearchObject
    {
        public int? BibliotekaId { get; set; }

        public DateTime? DatumGTE { get; set; }
        public DateTime? DatumLTE { get; set; }

        public int? CitalacId { get; set; }

        public bool? GeneralnaObavijest {  get; set; }

        public string? NaslovGTE { get; set; }
    }
}
