using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Uloge : ISoftDeletable
{
    public int UlogaId { get; set; }

    public string Naziv { get; set; } = null!;

    public virtual ICollection<KorisniciUloge> KorisniciUloges { get; set; } = new List<KorisniciUloge>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
