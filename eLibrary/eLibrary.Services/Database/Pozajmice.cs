using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Pozajmice : ISoftDeletable
{
    public int PozajmicaId { get; set; }

    public int CitalacId { get; set; }

    public int BibliotekaKnjigaId { get; set; }

    public DateTime DatumPreuzimanja { get; set; }

    public DateTime PreporuceniDatumVracanja { get; set; }

    public DateTime? StvarniDatumVracanja { get; set; }

    public int Trajanje { get; set; }

    public bool MoguceProduziti { get; set; }

    public virtual BibliotekaKnjige BibliotekaKnjiga { get; set; } = null!;

    public virtual Citaoci Citalac { get; set; } = null!;

    public virtual ICollection<Penali> Penalis { get; set; } = new List<Penali>();

    public virtual ICollection<ProduženjePozajmica> ProduženjePozajmicas { get; set; } = new List<ProduženjePozajmica>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
