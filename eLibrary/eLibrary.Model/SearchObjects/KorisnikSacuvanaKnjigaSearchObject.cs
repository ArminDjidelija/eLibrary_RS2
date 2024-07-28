using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class KorisnikSacuvanaKnjigaSearchObject:BaseSearchObject
    {
        public int? CitalacId { get; set; }

        public int? KnjigaId { get; set; }
    }
}
