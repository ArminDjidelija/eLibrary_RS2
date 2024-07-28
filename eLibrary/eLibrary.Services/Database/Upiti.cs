using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Upiti : ISoftDeletable
{
    public int UpitId { get; set; }

    public string Naslov { get; set; } = null!;

    public string Upit { get; set; } = null!;

    public string? Odgovor { get; set; }

    public int CitalacId { get; set; }

    public virtual Citaoci Citalac { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
