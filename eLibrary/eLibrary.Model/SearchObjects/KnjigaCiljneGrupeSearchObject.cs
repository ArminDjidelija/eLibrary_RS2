using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class KnjigaCiljneGrupeSearchObject:BaseSearchObject
    {
        public int? CiljnaGrupaId { get; set; }

        public int? KnjigaId { get; set; }
    }
}
