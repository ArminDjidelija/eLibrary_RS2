﻿using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KorisniciDTOs
{
    public class Korisnici
    {
        public int KorisnikId { get; set; }

        public string Ime { get; set; } 

        public string Prezime { get; set; } 

        public string Email { get; set; }

        public string Telefon { get; set; } 

        public string KorisnickoIme { get; set; } 

        public bool Status { get; set; }

        public int? BibliotekaId { get; set; }

        public virtual ICollection<BibliotekaUposleniDTO> BibliotekaUposlenis { get; set; } = new List<BibliotekaUposleniDTO>();

        public virtual ICollection<KorisniciUlogeDTO> KorisniciUloges { get; set; } = new List<KorisniciUlogeDTO>();
    }
}
