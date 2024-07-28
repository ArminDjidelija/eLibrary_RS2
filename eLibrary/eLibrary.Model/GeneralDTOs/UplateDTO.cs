using eLibrary.Model.BibliotekeDTOs;
using eLibrary.Model.CitaociDTOs;
using eLibrary.Model.TipoviUplatumDTOs;
using eLibrary.Model.ValuteDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.GeneralDTOs
{
    public class UplateDTO
    {
        public int UplataId { get; set; }

        public int CitalacId { get; set; }

        public int BibliotekaId { get; set; }

        public decimal Iznos { get; set; }

        public DateTime DatumUplate { get; set; }

        public int TipUplateId { get; set; }

        public int ValutaId { get; set; }

    }
}
