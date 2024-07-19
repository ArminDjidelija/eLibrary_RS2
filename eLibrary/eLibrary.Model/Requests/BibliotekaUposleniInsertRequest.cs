using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class BibliotekaUposleniInsertRequest
    {
        public int KorisnikId { get; set; }

        public int BibliotekaId { get; set; }

        public DateTime? DatumUposlenja { get; set; }
    }
}
