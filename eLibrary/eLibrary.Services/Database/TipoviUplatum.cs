using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class TipoviUplatum : ISoftDeletable
{
    public int TipUplateId { get; set; }

    public string Naziv { get; set; } = null!;

    public virtual ICollection<Uplate> Uplates { get; set; } = new List<Uplate>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
