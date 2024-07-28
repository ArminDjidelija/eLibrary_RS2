using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Obavijesti : ISoftDeletable
{
    public int ObavijestId { get; set; }

    public int? BibliotekaId { get; set; }

    public string Naslov { get; set; } = null!;

    public string Tekst { get; set; } = null!;

    public DateTime Datum { get; set; }

    public int? CitalacId { get; set; }

    public virtual Biblioteke? Biblioteka { get; set; }

    public virtual Citaoci? Citalac { get; set; }
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
