using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Rezervacije : ISoftDeletable
{
    public int RezervacijaId { get; set; }

    public int CitalacId { get; set; }

    public int BibliotekaKnjigaId { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public bool? Odobreno { get; set; }

    public DateTime? RokRezervacije { get; set; }

    public bool? Ponistena { get; set; }

    public virtual BibliotekaKnjige BibliotekaKnjiga { get; set; } = null!;

    public virtual Citaoci Citalac { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
