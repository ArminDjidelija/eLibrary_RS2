using System;
using System.Collections.Generic;
using eLibrary.Model.GeneralDTOs;

namespace eLibrary.Model.JeziciDTOs
{
    public class Jezici
    {
        public int JezikId { get; set; }
        public string Naziv { get; set; }
        public virtual ICollection<GeneralDTOs.KnjigeDTO> Knjiges { get; set; } = new List<GeneralDTOs.KnjigeDTO>();
    }
}
