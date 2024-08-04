using eLibrary.Model.CitaociDTOs;
using eLibrary.Model.KnjigeDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KorisnikSacuvaneKnjigeDTOs
{
    public class KorisnikSacuvaneKnjige
    {
        public int KorisnikSacuvanaKnjigaId { get; set; }

        public int CitalacId { get; set; }

        public int KnjigaId { get; set; }

        public virtual GeneralDTOs.CitaociDTO? Citalac { get; set; }

        public virtual Knjiga_KorisnikSacuvanaKnjigaDTO? Knjiga { get; set; } 
    }
}
