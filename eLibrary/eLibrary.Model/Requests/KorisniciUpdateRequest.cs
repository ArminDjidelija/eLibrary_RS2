using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class KorisniciUpdateRequest
    {
        public string Ime { get; set; }

        public string Prezime { get; set; }

        public string Telefon { get; set; }

        public string? StaraLozinka { get; set; }

        public string? Lozinka { get; set; }

        public string? LozinkaPotvrda { get; set; }
    }
}
