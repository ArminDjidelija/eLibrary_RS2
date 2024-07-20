using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.GeneralDTOs
{
    public class CitaociDTO
    {
        public int CitalacId { get; set; }

        public string Ime { get; set; }

        public string Prezime { get; set; }

        public string Email { get; set; }

        public string Telefon { get; set; }

        public string KorisnickoIme { get; set; }

        public bool Status { get; set; }

        public string? Institucija { get; set; }

        public DateTime DatumRegistracije { get; set; }

        public int KantonId { get; set; }
    }
}
