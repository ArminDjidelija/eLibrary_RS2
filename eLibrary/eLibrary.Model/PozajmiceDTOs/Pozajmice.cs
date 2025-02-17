﻿using eLibrary.Model.BibliotekaKnjigeDTOs;
using eLibrary.Model.CitaociDTOs;
using eLibrary.Model.PenaliDTOs;
using eLibrary.Model.ProduzenjePozajmicaDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.PozajmiceDTOs
{
    public class Pozajmice
    {
        public int PozajmicaId { get; set; }

        public int CitalacId { get; set; }

        public int BibliotekaKnjigaId { get; set; }

        public DateTime DatumPreuzimanja { get; set; }

        public DateTime PreporuceniDatumVracanja { get; set; }

        public DateTime? StvarniDatumVracanja { get; set; }

        public int Trajanje { get; set; }

        public bool MoguceProduziti { get; set; }

        public virtual BibliotekaKnjige? BibliotekaKnjiga { get; set; }

        public virtual Citaoci? Citalac { get; set; } 

        public virtual ICollection<Penali> Penalis { get; set; } = new List<Penali>();

        public virtual ICollection<ProduzenjePozajmica> ProduzenjePozajmicas { get; set; } = new List<ProduzenjePozajmica>();
    }
}
