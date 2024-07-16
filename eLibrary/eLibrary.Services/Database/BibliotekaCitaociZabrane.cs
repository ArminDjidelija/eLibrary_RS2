using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class BibliotekaCitaociZabrane : ISoftDeletable
{
    public int BibliotekaCitaocZabranaId { get; set; }

    public DateTime RokZabrane { get; set; }

    public int BibliotekaId { get; set; }

    public int CitalacId { get; set; }

    public virtual Biblioteke Biblioteka { get; set; } = null!;

    public virtual Citaoci Citalac { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
