using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Knjige : ISoftDeletable
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

    public int VrsteGradeId { get; set; }

    public int JezikId { get; set; }

    public virtual ICollection<BibliotekaKnjige> BibliotekaKnjiges { get; set; } = new List<BibliotekaKnjige>();

    public virtual Izdavaci Izdavac { get; set; } = null!;

    public virtual Jezici Jezik { get; set; } = null!;

    public virtual ICollection<KnjigaAutori> KnjigaAutoris { get; set; } = new List<KnjigaAutori>();

    public virtual ICollection<KnjigaCiljneGrupe> KnjigaCiljneGrupes { get; set; } = new List<KnjigaCiljneGrupe>();

    public virtual ICollection<KnjigaVrsteSadrzaja> KnjigaVrsteSadrzajas { get; set; } = new List<KnjigaVrsteSadrzaja>();

    public virtual ICollection<KorisnikSacuvanaKnjiga> KorisnikSacuvanaKnjigas { get; set; } = new List<KorisnikSacuvanaKnjiga>();

    public virtual VrsteGrade VrstaGrade { get; set; } = null!;

    public virtual Uvezi Uvez { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
