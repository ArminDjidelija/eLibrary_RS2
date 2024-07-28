using eLibrary.Model.BibliotekeDTOs;
using eLibrary.Model.KorisniciDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.BibliotekaUposleniDTOs
{
    public class BibliotekaUposleni
    {
        public int KorisnikId { get; set; }

        public int BibliotekaId { get; set; }

        public int BibliotekaUposleniId { get; set; }

        public DateTime? DatumUposlenja { get; set; }

        public virtual GeneralDTOs.BibliotekeDTO? Biblioteka { get; set; }

        public virtual GeneralDTOs.KorisniciDTO? Korisnik { get; set; } 
    }
}
