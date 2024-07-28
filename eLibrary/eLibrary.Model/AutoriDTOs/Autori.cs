using System.Collections.Generic;
using eLibrary.Model.GeneralDTOs;

namespace eLibrary.Model.AutoriDTOs
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
