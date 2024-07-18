using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.BibliotekeDTOs
{
    public class Biblioteke
    {
        public int BibliotekaId { get; set; }

        public string Naziv { get; set; }

        public string Adresa { get; set; }

        public string? Opis { get; set; }

        public string? Web { get; set; }

        public string? Telefon { get; set; }

        public string? Mail { get; set; }

        public int KantonId { get; set; }
        public virtual KantoniDTO Kanton { get; set; } 

    }
}
