using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.UlogeDTOs
{
    public class Uloge
    {
        public int UlogaId { get; set; }

        public string Naziv { get; set; } 

        //public virtual ICollection<GeneralDTO.KorisniciUlogeDTO> KorisniciUloges { get; set; } = new List<GeneralDTO.KorisniciUlogeDTO>();
    }
}
