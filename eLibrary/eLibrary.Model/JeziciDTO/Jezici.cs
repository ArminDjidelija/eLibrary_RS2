using System;
using System.Collections.Generic;

namespace eLibrary.Model.JeziciDTO
{
    public class Jezici
    {
        public int JezikId { get; set; }
        public string Naziv { get; set; }
        public virtual ICollection<KnjigeDTO> Knjiges { get; set; } = new List<KnjigeDTO>();
    }
}
