using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class VrsteSadrzaja : ISoftDeletable
{
    public int VrstaSadrzajaId { get; set; }

    public string Naziv { get; set; } = null!;

    public virtual ICollection<KnjigaVrsteSadrzaja> KnjigaVrsteSadrzajas { get; set; } = new List<KnjigaVrsteSadrzaja>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
