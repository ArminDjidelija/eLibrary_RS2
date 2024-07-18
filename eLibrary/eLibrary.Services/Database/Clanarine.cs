using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Clanarine : ISoftDeletable
{
    public int ClanarinaId { get; set; }

    public int CitalacId { get; set; }

    public int BibliotekaId { get; set; }

    public int UplateId { get; set; }

    public int TipClanarineBibliotekaId { get; set; }

    public decimal Iznos { get; set; }

    public DateTime Pocetak { get; set; }

    public DateTime Kraj { get; set; }

    public virtual Biblioteke Biblioteka { get; set; } = null!;

    public virtual Citaoci Citalac { get; set; } = null!;

    public virtual TipClanarineBiblioteke TipClanarineBiblioteka { get; set; } = null!;

    public virtual Uplate Uplate { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
