using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class ClanarineInsertRequest
    {
        public int CitalacId { get; set; }

        public int BibliotekaId { get; set; }

        //public int UplateId { get; set; }

        public int TipClanarineBibliotekaId { get; set; }

        public int TipUplateId { get; set; }


        //potrebni podaci za stripe
    }
}
