using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KnjigeDTOs
{
    public class Knjige
    {
        public int KnjigaId { get; set; }

        public string Naslov { get; set; } = null!;

        public int GodinaIzdanja { get; set; }

        public int BrojIzdanja { get; set; }

        public int BrojStranica { get; set; }

        public string? Isbn { get; set; }

        public string? Napomena { get; set; }

        public byte[]? Slika { get; set; }

        public int UvezId { get; set; }

        public int IzdavacId { get; set; }

        public int JezikId { get; set; }

        public virtual ICollection<BibliotekaKnjigeDTO> BibliotekaKnjiges { get; set; } = new List<BibliotekaKnjigeDTO>();

        public virtual IzdavaciDTO Izdavac { get; set; }

        public virtual JeziciDTO Jezik { get; set; } 

        public virtual ICollection<GeneralDTOs.KnjigaAutoriDTO> KnjigaAutoris { get; set; } = new List<GeneralDTOs.KnjigaAutoriDTO>();

        public virtual ICollection<GeneralDTOs.KnjigaCiljneGrupeDTO> KnjigaCiljneGrupes { get; set; } = new List<GeneralDTOs.KnjigaCiljneGrupeDTO>();

        public virtual ICollection<GeneralDTOs.KnjigaVrsteSadrzajaDTO> KnjigaVrsteSadrzajas { get; set; } = new List<GeneralDTOs.KnjigaVrsteSadrzajaDTO>();

        public virtual ICollection<GeneralDTOs.KorisnikSacuvanaKnjigaDTO> KorisnikSacuvanaKnjigas { get; set; } = new List<GeneralDTOs.KorisnikSacuvanaKnjigaDTO>();
    }
}
