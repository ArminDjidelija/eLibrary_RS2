using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Autori : ISoftDeletable
{
    public int AutorId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public int? GodinaRodjenja { get; set; }
    
    public virtual ICollection<KnjigaAutori> KnjigaAutoris { get; set; } = new List<KnjigaAutori>();
    public bool IsDeleted { get ; set; }=false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;

    public string ImePrezime => Ime + " " + Prezime;
}
