using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class BibliotekaKnjige : ISoftDeletable
{
    public int BibliotekaKnjigaId { get; set; }

    public int BibliotekaId { get; set; }

    public int KnjigaId { get; set; }

    public int BrojKopija { get; set; }

    public DateTime DatumDodavanja { get; set; }

    public string? Lokacija { get; set; }

    public int? DostupnoCitaonica { get; set; }

    public int? DostupnoPozajmica { get; set; }

    public virtual Biblioteke Biblioteka { get; set; } = null!;

    public virtual Knjige Knjiga { get; set; } = null!;

    public virtual ICollection<Pozajmice> Pozajmices { get; set; } = new List<Pozajmice>();

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
