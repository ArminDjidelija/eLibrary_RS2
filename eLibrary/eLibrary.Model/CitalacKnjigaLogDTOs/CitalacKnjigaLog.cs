using eLibrary.Model.CitaociDTOs;
using eLibrary.Model.KnjigeDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.CitalacKnjigaLogDTOs
{
    public class CitalacKnjigaLog
    {
        public int CitalacKnjigaLogId { get; set; }
        public int KnjigaId { get; set; }
        public virtual GeneralDTOs.KnjigeDTO? Knjiga { get; set; }
        public int CitalacId { get; set; }
        public virtual GeneralDTOs.CitaociDTO? Citalac { get; set; }
    }
}
