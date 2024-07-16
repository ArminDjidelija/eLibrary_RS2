using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Uplate : ISoftDeletable
{
    public int UplataId { get; set; }

    public int CitalacId { get; set; }

    public int BibliotekaId { get; set; }

    public decimal Iznos { get; set; }

    public DateTime DatumUplate { get; set; }

    public int TipUplateId { get; set; }

    public int ValutaId { get; set; }

    public virtual Biblioteke Biblioteka { get; set; } = null!;

    public virtual Citaoci Citalac { get; set; } = null!;

    public virtual ICollection<Clanarine> Clanarines { get; set; } = new List<Clanarine>();

    public virtual ICollection<Penali> Penalis { get; set; } = new List<Penali>();

    public virtual TipoviUplatum TipUplate { get; set; } = null!;

    public virtual Valute Valuta { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
