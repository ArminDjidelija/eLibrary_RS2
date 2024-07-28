using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KantoniDTOs
{
    public class Kantoni
    {
        public int KantonId { get; set; }

        public string Naziv { get; set; }

        public string Skracenica { get; set; }

        public virtual ICollection<GeneralDTOs.BibliotekeDTO> Bibliotekes { get; set; } = new List<GeneralDTOs.BibliotekeDTO>();
    }
}
