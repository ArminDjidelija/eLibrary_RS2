using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.GeneralDTOs
{
    public class AutoriDTO
    {
        public int AutorId { get; set; }

        public string Ime { get; set; } 

        public string Prezime { get; set; } 

        public int? GodinaRodjenja { get; set; }
    }
}
