using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Rukovodilac : ISoftDeletable
{
    public int RukovodilacId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Kontakt { get; set; }

    public virtual ICollection<Biblioteke> Bibliotekes { get; set; } = new List<Biblioteke>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
