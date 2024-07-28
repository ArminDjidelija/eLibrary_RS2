using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class KnjigeSearchObject:BaseSearchObject
    {
        public string? NaslovGTE { get; set; }

        public int? GodinaIzdanjaGTE { get; set; }

        public int? GodinaIzdanjaLTE { get; set; }

        public int? BrojStranicaGTE { get; set; }

        public int? BrojStranicaLTE { get; set; }

        public string? Isbn { get; set; }

        public int? UvezId { get; set; }

        public int? BibliotekaId { get; set; }

        public int? IzdavacId { get; set; }

        public int? VrsteGradeId { get; set; }

        public int? JezikId { get; set; }

        public int? KnjigaId { get; set; }

        public string? Autor {  get; set; }
    }
}
