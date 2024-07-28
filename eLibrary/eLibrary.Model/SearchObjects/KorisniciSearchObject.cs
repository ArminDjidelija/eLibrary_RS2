using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class KorisniciSearchObject : BaseSearchObject
    {
        public string? ImeGTE { get; set; }

        public string? PrezimeGTE { get; set; }

        public string? ImePrezimeGTE { get; set; }

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public string? KorisnickoIme { get; set; }

        public bool? Status { get; set; }

        public int? UlogaId { get; set; }
    }
}
