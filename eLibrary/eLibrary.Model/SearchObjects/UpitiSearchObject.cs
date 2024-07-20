using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class UpitiSearchObject:BaseSearchObject
    {
        public string? ImeGTE { get; set; }
        public string? PrezimeGTE { get; set; }
        public string? ImePrezimeGTE { get; set; }
        public int? CitalacId { get; set; }
        public bool? Odgovoreno { get; set; }
    }
}
