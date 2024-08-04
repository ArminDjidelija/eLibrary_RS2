using eLibrary.Model.KnjigeDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KorisnikSacuvaneKnjigeDTOs
{
    public class Knjiga_KorisnikSacuvanaKnjigaDTO
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

        public int VrsteGradeId { get; set; }

        public virtual IzdavaciDTO? Izdavac { get; set; }

        public virtual JeziciDTO? Jezik { get; set; }

        public virtual GeneralDTOs.UvezDTO? Uvez { get; set; }

       
    }
}
