using eLibrary.Model.KantoniDTOs;
using System;
using System.Collections.Generic;
using System.Numerics;
using System.Text;

namespace eLibrary.Model.CitaociDTOs
{
    public class Citaoci
    {
        public int CitalacId { get; set; }

        public string Ime { get; set; } 

        public string Prezime { get; set; } 

        public string Email { get; set; }

        public string Telefon { get; set; } 

        public string KorisnickoIme { get; set; }

    
        public bool Status { get; set; }

        public string? Institucija { get; set; }

        public DateTime DatumRegistracije { get; set; }

        public int KantonId { get; set; }

        public virtual ICollection<GeneralDTOs.BibliotekaCitaociZabraneDTO> BibliotekaCitaociZabranes { get; set; } = new List<GeneralDTOs.BibliotekaCitaociZabraneDTO>();

        public virtual ICollection<GeneralDTOs.ClanarineDTO> Clanarines { get; set; } = new List<GeneralDTOs.ClanarineDTO>();

        public virtual Kantoni? Kanton { get; set; } 

        public virtual ICollection<GeneralDTOs.KorisnikSacuvanaKnjigaDTO> KorisnikSacuvanaKnjigas { get; set; } = new List<GeneralDTOs.KorisnikSacuvanaKnjigaDTO>();

        public virtual ICollection<GeneralDTOs.ObavijestiDTO> Obavijestis { get; set; } = new List<GeneralDTOs.ObavijestiDTO>();

        public virtual ICollection<GeneralDTOs.PozajmiceDTO> Pozajmices { get; set; } = new List<GeneralDTOs.PozajmiceDTO>();

        public virtual ICollection<GeneralDTOs.RezervacijeDTO> Rezervacijes { get; set; } = new List<GeneralDTOs.RezervacijeDTO>();

        public virtual ICollection<GeneralDTOs.UpitiDTO> Upitis { get; set; } = new List<GeneralDTOs.UpitiDTO>();

        public virtual ICollection<GeneralDTOs.UplateDTO> Uplates { get; set; } = new List<GeneralDTOs.UplateDTO>();
    }
}
