using eLibrary.Model.KnjigeDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.UveziDTOs
{
    public class Uvezi
    {
        public int UvezId { get; set; }

        public string Naziv { get; set; }

        public virtual ICollection<GeneralDTOs.KnjigeDTO> Knjiges { get; set; } = new List<GeneralDTOs.KnjigeDTO>();
    }
}
