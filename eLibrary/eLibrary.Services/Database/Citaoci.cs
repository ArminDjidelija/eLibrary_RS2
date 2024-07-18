using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Citaoci : ISoftDeletable
{
    public int CitalacId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Telefon { get; set; } = null!;

    public string KorisnickoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public bool Status { get; set; }

    public string? Institucija { get; set; }

    public DateTime DatumRegistracije { get; set; }

    public int KantonId { get; set; }

    public virtual ICollection<BibliotekaCitaociZabrane> BibliotekaCitaociZabranes { get; set; } = new List<BibliotekaCitaociZabrane>();

    public virtual ICollection<Clanarine> Clanarines { get; set; } = new List<Clanarine>();

    public virtual Kantoni Kanton { get; set; } = null!;

    public virtual ICollection<KorisnikSacuvanaKnjiga> KorisnikSacuvanaKnjigas { get; set; } = new List<KorisnikSacuvanaKnjiga>();

    public virtual ICollection<Obavijesti> Obavijestis { get; set; } = new List<Obavijesti>();

    public virtual ICollection<Pozajmice> Pozajmices { get; set; } = new List<Pozajmice>();

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();

    public virtual ICollection<Upiti> Upitis { get; set; } = new List<Upiti>();

    public virtual ICollection<Uplate> Uplates { get; set; } = new List<Uplate>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
