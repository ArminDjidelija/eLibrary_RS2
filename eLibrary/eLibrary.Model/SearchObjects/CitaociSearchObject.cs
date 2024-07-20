using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class CitaociSearchObject:BaseSearchObject
    {
        public string? ImeGTE { get; set; }

        public string? PrezimeGTE { get; set; }

        public string? ImePrezimeGTE { get; set; }

        public string? Email { get; set; }

        public string? KorisnickoIme { get; set; }


        public bool? Status { get; set; }

        public string? InstitucijaGTE { get; set; }

        public int? KantonId { get; set; }
    }
}
