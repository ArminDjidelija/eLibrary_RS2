using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Biblioteke : ISoftDeletable
{
    public int BibliotekaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Adresa { get; set; } = null!;

    public string? Opis { get; set; }

    public string? Web { get; set; }

    public string? Telefon { get; set; }

    public string? Mail { get; set; }

    //public int? RukovodilacId { get; set; }

    public int KantonId { get; set; }

    public virtual ICollection<BibliotekaCitaociZabrane> BibliotekaCitaociZabranes { get; set; } = new List<BibliotekaCitaociZabrane>();

    public virtual ICollection<BibliotekaKnjige> BibliotekaKnjiges { get; set; } = new List<BibliotekaKnjige>();

    public virtual ICollection<BibliotekaUposleni> BibliotekaUposlenis { get; set; } = new List<BibliotekaUposleni>();

    public virtual ICollection<Clanarine> Clanarines { get; set; } = new List<Clanarine>();

    public virtual Kantoni Kanton { get; set; } = null!;

    public virtual ICollection<Obavijesti> Obavijestis { get; set; } = new List<Obavijesti>();

    //public virtual Rukovodilac? Rukovodilac { get; set; }

    public virtual ICollection<TipClanarineBiblioteke> TipClanarineBibliotekes { get; set; } = new List<TipClanarineBiblioteke>();

    public virtual ICollection<Uplate> Uplates { get; set; } = new List<Uplate>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; } = DateTime.Now;
}
