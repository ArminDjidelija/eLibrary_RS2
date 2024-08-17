using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class CitalacKnjigaLogUpsertRequest
    {
        public int CitalacId { get; set; }
        public int KnjigaId { get; set; }
    }
}
