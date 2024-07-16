using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class KorisniciUloge : ISoftDeletable
{
    public int KorisnikUlogaId { get; set; }

    public int UlogaId { get; set; }

    public int KorisnikId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Uloge Uloga { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
