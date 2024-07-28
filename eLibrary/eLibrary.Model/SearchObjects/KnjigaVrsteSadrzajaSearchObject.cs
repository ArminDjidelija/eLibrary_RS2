using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class KnjigaVrsteSadrzajaSearchObject:BaseSearchObject
    {
        public int? KnjigaId { get; set; }

        public int? VrstaSadrzajaId { get; set; }
    }
}
