using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Kantoni : ISoftDeletable
{
    public int KantonId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Skracenica { get; set; } = null!;

    public virtual ICollection<Biblioteke> Bibliotekes { get; set; } = new List<Biblioteke>();

    public virtual ICollection<Citaoci> Citaocis { get; set; } = new List<Citaoci>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
