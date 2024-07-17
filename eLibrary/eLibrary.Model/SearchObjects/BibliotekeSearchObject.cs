using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class BibliotekeSearchObject:BaseSearchObject
    {
        public string? NazivGTE { get; set; }

        public string? AdresaGTE { get; set; }

        public int? KantonId { get; set; }
    }
}
