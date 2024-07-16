using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model
{
    public class Knjige
    {
        public int KnjigaId { get; set; }

        public string Naslov { get; set; }

        public int GodinaIzdanja { get; set; }

        public int BrojIzdanja { get; set; }

        public int BrojStranica { get; set; }

        public string? Isbn { get; set; }

        public string? Napomena { get; set; }

        public byte[]? Slika { get; set; }

        public int UvezId { get; set; }

        public int IzdavacId { get; set; }

        public int JezikId { get; set; }

        public virtual Jezici Jezik { get; set; } = null!;

        public virtual ICollection<KnjigaAutori> KnjigaAutoris { get; set; } = new List<KnjigaAutori>();
              

        public virtual Uvezi Uvez { get; set; } = null!;
    }
}
