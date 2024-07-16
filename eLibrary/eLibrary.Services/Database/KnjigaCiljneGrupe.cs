using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class KnjigaCiljneGrupe : ISoftDeletable
{
    public int KnjigaCiljnaGrupaId { get; set; }

    public int CiljnaGrupaId { get; set; }

    public int KnjigaId { get; set; }

    public virtual CiljneGrupe CiljnaGrupa { get; set; } = null!;

    public virtual Knjige Knjiga { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
