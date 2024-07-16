using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model
{
    public class Autori
    {
        public int AutorId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public int? GodinaRodjenja { get; set; }

        public ICollection<KnjigaAutori>? KnjigaAutoris { get; set; }
    }
}
