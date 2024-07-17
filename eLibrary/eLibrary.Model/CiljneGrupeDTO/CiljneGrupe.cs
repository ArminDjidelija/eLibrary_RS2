using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.CiljneGrupeDTO
{
    public class CiljneGrupe
    {
        public int CiljnaGrupaId { get; set; }
        public string Naziv { get; set; }
        public virtual ICollection<KnjigaCiljneGrupeDTO> KnjigaCiljneGrupes { get; set; } = new List<KnjigaCiljneGrupeDTO>();

    }
}
