using eLibrary.Model.BibliotekeDTOs;
using eLibrary.Model.CitaociDTOs;
using eLibrary.Model.PenaliDTOs;
using eLibrary.Model.TipoviUplatumDTOs;
using eLibrary.Model.ValuteDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.UplateDTOs
{
    public class Uplate
    {
        public int UplataId { get; set; }

        public int CitalacId { get; set; }

        public int BibliotekaId { get; set; }

        public decimal Iznos { get; set; }

        public DateTime DatumUplate { get; set; }

        public int TipUplateId { get; set; }

        public int ValutaId { get; set; }

        public virtual Biblioteke Biblioteka { get; set; } = null!;

        public virtual GeneralDTOs.CitaociDTO Citalac { get; set; } = null!;

        public virtual ICollection<GeneralDTOs.ClanarineDTO> Clanarines { get; set; } = new List<GeneralDTOs.ClanarineDTO>();

        public virtual ICollection<Penali> Penalis { get; set; } = new List<Penali>();

        public virtual TipoviUplatumDTOs.TipoviUplata TipUplate { get; set; } = null!;

        public virtual Valute Valuta { get; set; } = null!;
    }
}
