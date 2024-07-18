using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.ValuteDTOs
{
    public class Valute
    {
        public int ValutaId { get; set; }

        public string Naziv { get; set; } 

        public string? Skracenica { get; set; }
    }
}
