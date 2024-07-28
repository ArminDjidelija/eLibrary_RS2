using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class AutoriSearchObject:BaseSearchObject
    {
        public string? ImeGTE { get; set; }
        public string? PrezimeGTE { get; set; }
        public string? ImePrezimeGTE { get; set; }
        public int? GodinaRodjenjaGTE { get; set; }
        public int? GodinaRodjenjaLTE { get; set; }
    }
}
