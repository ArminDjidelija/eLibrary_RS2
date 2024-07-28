using eLibrary.Model.KnjigeDTOs;
using eLibrary.Model.VrsteSadrzajaDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KnjigaVrsteSadrzajaDTOs
{
    public class KnjigaVrsteSadrzaja
    {
        public int KnjigaVrstaSadrzajaId { get; set; }

        public int VrstaSadrzajaId { get; set; }

        public int KnjigaId { get; set; }

        public virtual GeneralDTOs.KnjigeDTO Knjiga { get; set; } 

        public virtual GeneralDTOs.VrsteSadrzajaDTO VrstaSadrzaja { get; set; } 
    }
}
