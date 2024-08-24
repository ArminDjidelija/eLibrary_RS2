using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class KnjigeUpdateRequest
    {
        public string Naslov { get; set; }

        public int GodinaIzdanja { get; set; }

        public int BrojIzdanja { get; set; }

        public int BrojStranica { get; set; }

        public string? Isbn { get; set; }

        public string? Napomena { get; set; }

        public byte[]? Slika { get; set; }

        public int UvezId { get; set; }

        public int IzdavacId { get; set; }

        public int? VrsteGradeId { get; set; }

        public int JezikId { get; set; }

        public List<int> Autori { get; set; }

        public List<int> CiljneGrupe { get; set; }

        public List<int> VrsteSadrzaja { get; set; }
    }
}
