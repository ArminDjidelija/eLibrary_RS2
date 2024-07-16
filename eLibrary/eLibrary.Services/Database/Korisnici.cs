using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Korisnici : ISoftDeletable
{
    public int KorisnikId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Telefon { get; set; } = null!;

    public string KorisnickoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public bool Status { get; set; }

    public virtual ICollection<BibliotekaUposleni> BibliotekaUposlenis { get; set; } = new List<BibliotekaUposleni>();

    public virtual ICollection<KorisniciUloge> KorisniciUloges { get; set; } = new List<KorisniciUloge>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
