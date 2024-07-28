using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class KnjigaAutoriSearchObject:BaseSearchObject
    {
        public int? AutorId { get; set; }

        public int? KnjigaId { get; set; }
    }
}
