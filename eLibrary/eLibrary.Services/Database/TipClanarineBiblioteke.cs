using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class TipClanarineBiblioteke : ISoftDeletable
{
    public int TipClanarineBibliotekaId { get; set; }

    public string Naziv { get; set; } = null!;

    public int Trajanje { get; set; }

    public decimal Iznos { get; set; }

    public int BibliotekaId { get; set; }

    public int ValutaId { get; set; }

    public virtual Biblioteke Biblioteka { get; set; } = null!;

    public virtual ICollection<Clanarine> Clanarines { get; set; } = new List<Clanarine>();

    public virtual Valute Valuta { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
