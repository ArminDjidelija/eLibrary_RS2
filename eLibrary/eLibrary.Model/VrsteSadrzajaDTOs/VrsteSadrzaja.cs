using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.VrsteSadrzajaDTOs
{
    public class VrsteSadrzaja
    {
        public int VrstaSadrzajaId { get; set; }

        public string Naziv { get; set; }

        public ICollection<KnjigaVrsteSadrzajaDTO> KnjigaVrsteSadrzajas { get; set; } = new List<KnjigaVrsteSadrzajaDTO>();
    }
}
