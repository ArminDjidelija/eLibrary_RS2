using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class BibliotekaUposleni : ISoftDeletable
{
    public int KorisnikId { get; set; }

    public int BibliotekaId { get; set; }

    public int BibliotekaUposleniId { get; set; }

    public DateTime? DatumUposlenja { get; set; }

    public virtual Biblioteke Biblioteka { get; set; } = null!;

    public virtual Korisnici Korisnik { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
