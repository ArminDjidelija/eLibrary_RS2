using eLibrary.Model.GeneralDTO;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KantoniDTO
{
    public class Kantoni
    {
        public int KantonId { get; set; }

        public string Naziv { get; set; }

        public string Skracenica { get; set; }

        public virtual ICollection<GeneralDTO.BibliotekeDTO> Bibliotekes { get; set; } = new List<GeneralDTO.BibliotekeDTO>();
    }
}
