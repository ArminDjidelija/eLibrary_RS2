using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class KnjigaVrsteSadrzaja : ISoftDeletable
{
    public int KnjigaVrstaSadrzajaId { get; set; }

    public int VrstaSadrzajaId { get; set; }

    public int KnjigaId { get; set; }

    public virtual Knjige Knjiga { get; set; } = null!;

    public virtual VrsteSadrzaja VrstaSadrzaja { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
