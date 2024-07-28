using eLibrary.Model.CiljneGrupeDTOs;
using eLibrary.Model.KnjigeDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KnjigaCiljneGrupeDTOs
{
    public class KnjigaCiljneGrupe
    {
        public int KnjigaCiljnaGrupaId { get; set; }

        public int CiljnaGrupaId { get; set; }

        public int KnjigaId { get; set; }

        public virtual GeneralDTOs.CiljneGrupeDTO? CiljnaGrupa { get; set; }

        public virtual GeneralDTOs.KnjigeDTO? Knjiga { get; set; } 
    }
}
