using eLibrary.Model.BibliotekeDTOs;
using eLibrary.Model.KnjigeDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.BibliotekaKnjigeDTOs
{
    public class BibliotekaKnjige
    {
        public int BibliotekaKnjigaId { get; set; }

        public int BibliotekaId { get; set; }

        public int KnjigaId { get; set; }

        public int BrojKopija { get; set; }

        public DateTime DatumDodavanja { get; set; }

        public string? Lokacija { get; set; }

        public int? DostupnoCitaonica { get; set; }

        public int? DostupnoPozajmica { get; set; }

        public virtual Biblioteke Biblioteka { get; set; } = null!;

        public virtual GeneralDTOs.KnjigeDTO Knjiga { get; set; } = null!;

        public virtual ICollection<GeneralDTOs.PozajmiceDTO> Pozajmices { get; set; } = new List<GeneralDTOs.PozajmiceDTO>();

        public virtual ICollection<GeneralDTOs.RezervacijeDTO> Rezervacijes { get; set; } = new List<GeneralDTOs.RezervacijeDTO>();
    }
}
