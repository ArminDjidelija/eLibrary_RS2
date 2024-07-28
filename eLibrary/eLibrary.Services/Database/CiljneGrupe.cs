using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class CiljneGrupe : ISoftDeletable
{
    public int CiljnaGrupaId { get; set; }

    public string Naziv { get; set; } = null!;

    public virtual ICollection<KnjigaCiljneGrupe> KnjigaCiljneGrupes { get; set; } = new List<KnjigaCiljneGrupe>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
