using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class KnjigaAutori : ISoftDeletable
{
    public int KnjigaAutorId { get; set; }

    public int AutorId { get; set; }

    public int KnjigaId { get; set; }

    public virtual Autori Autor { get; set; } = null!;

    public virtual Knjige Knjiga { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
