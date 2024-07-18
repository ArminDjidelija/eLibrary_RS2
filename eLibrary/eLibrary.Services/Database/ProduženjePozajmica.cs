using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class ProduženjePozajmica : ISoftDeletable
{
    public int ProduzenjePozajmiceId { get; set; }

    public int Produzenje { get; set; }

    public DateTime DatumZahtjeva { get; set; }

    public DateTime NoviRok { get; set; }

    public bool? Odobreno { get; set; }

    public int PozajmicaId { get; set; }

    public virtual Pozajmice Pozajmica { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
