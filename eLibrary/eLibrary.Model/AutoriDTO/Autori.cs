using System.Collections.Generic;

namespace eLibrary.Model.AutoriDTO
{
    public class Autori
    {
        public int AutorId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public int? GodinaRodjenja { get; set; }

        public ICollection<KnjigaAutoriDTO> KnjigaAutoris { get; set; } = new List<KnjigaAutoriDTO>();
    }
}
