using eLibrary.Model.PozajmiceDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.ProduzenjePozajmicaDTOs
{
    public class ProduzenjePozajmica
    {
        public int ProduzenjePozajmiceId { get; set; }

        public int Produzenje { get; set; }

        public DateTime DatumZahtjeva { get; set; }

        public DateTime NoviRok { get; set; }

        public bool? Odobreno { get; set; }

        public int PozajmicaId { get; set; }

        public virtual GeneralDTOs.PozajmiceDTO? Pozajmica { get; set; } 
    }
}
