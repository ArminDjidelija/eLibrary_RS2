using System;
using System.Collections.Generic;
using System.Text;
using eLibrary.Model.GeneralDTOs;

namespace eLibrary.Model.CiljneGrupeDTOs
{
    public class CiljneGrupe
    {
        public int CiljnaGrupaId { get; set; }
        public string Naziv { get; set; }
        public virtual ICollection<KnjigaCiljneGrupeDTO> KnjigaCiljneGrupes { get; set; } = new List<KnjigaCiljneGrupeDTO>();

    }
}
