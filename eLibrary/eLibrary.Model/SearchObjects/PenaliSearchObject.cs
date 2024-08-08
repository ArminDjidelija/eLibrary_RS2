using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class PenaliSearchObject:BaseSearchObject
    {
        public int? CitalacId { get; set; }
        public int? BibliotekaId {  get; set; }
        public bool? Placeno {  get; set; }
        public int PozajmicaId { get; set; }
    }
}
