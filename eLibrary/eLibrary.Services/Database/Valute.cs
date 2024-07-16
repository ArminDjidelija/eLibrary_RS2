using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Valute : ISoftDeletable
{
    public int ValutaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Skracenica { get; set; }

    public virtual ICollection<TipClanarineBiblioteke> TipClanarineBibliotekes { get; set; } = new List<TipClanarineBiblioteke>();

    public virtual ICollection<Uplate> Uplates { get; set; } = new List<Uplate>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
