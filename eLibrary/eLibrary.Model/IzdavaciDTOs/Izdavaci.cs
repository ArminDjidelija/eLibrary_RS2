using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.IzdavaciDTOs
{
    public class Izdavaci
    {
        public int IzdavacId { get; set; }

        public string Naziv { get; set; }

        public virtual ICollection<GeneralDTOs.KnjigeDTO> Knjiges { get; set; } = new List<GeneralDTOs.KnjigeDTO>();
    }
}
