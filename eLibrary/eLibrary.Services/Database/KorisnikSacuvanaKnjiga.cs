using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class KorisnikSacuvanaKnjiga : ISoftDeletable
{
    public int KorisnikSacuvanaKnjigaId { get; set; }

    public int CitalacId { get; set; }

    public int KnjigaId { get; set; }

    public virtual Citaoci Citalac { get; set; } = null!;

    public virtual Knjige Knjiga { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
