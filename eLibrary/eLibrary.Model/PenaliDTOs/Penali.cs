using eLibrary.Model.PozajmiceDTOs;
using System;
using System.Collections.Generic;
using System.Numerics;
using System.Text;

namespace eLibrary.Model.PenaliDTOs
{
    public class Penali
    {
        public int PenalId { get; set; }

        public int PozajmicaId { get; set; }

        public string Opis { get; set; } = null!;

        public decimal Iznos { get; set; }

        public int? UplataId { get; set; }

        public int? ValutaId { get; set; }

        public virtual GeneralDTOs.PozajmiceDTO Pozajmica { get; set; } 

        public virtual GeneralDTOs.UplateDTO? Uplata { get; set; }

        public virtual ValuteDTOs.Valute? Valuta { get; set; }
    }
}
