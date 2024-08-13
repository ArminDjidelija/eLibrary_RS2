using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.Database
{
    public class CitalacKnjigaLog
    {
        public int CitalacKnjigaLogId { get; set; }
        public int KnjigaId { get; set; }
        public virtual Knjige Knjiga { get; set; }
        public int CitalacId { get; set; }
        public virtual Citaoci Citalac { get; set; }
    }
}
