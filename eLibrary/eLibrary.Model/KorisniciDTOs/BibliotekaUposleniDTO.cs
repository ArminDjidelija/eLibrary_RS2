using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KorisniciDTOs
{
    public class BibliotekaUposleniDTO
    {
        public int KorisnikId { get; set; }

        public int BibliotekaId { get; set; }

        public int BibliotekaUposleniId { get; set; }

        public DateTime? DatumUposlenja { get; set; }
    }
}
