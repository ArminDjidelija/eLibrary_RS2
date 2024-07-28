using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class UpitiInsertRequest
    {
        public string Naslov { get; set; }

        public string Upit { get; set; }

        public int CitalacId { get; set; }
    }
}
