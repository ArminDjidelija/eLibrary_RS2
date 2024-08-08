using eLibrary.Model.ValuteDTOs;
using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Penali : ISoftDeletable
{
    public int PenalId { get; set; }

    public int PozajmicaId { get; set; }

    public string Opis { get; set; } = null!;

    public decimal Iznos { get; set; }

    public int? UplataId { get; set; }

    public int? ValutaId { get; set; }

    public virtual Valute Valuta { get; set; }

    public virtual Pozajmice Pozajmica { get; set; } = null!;

    public virtual Uplate? Uplata { get; set; }
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
