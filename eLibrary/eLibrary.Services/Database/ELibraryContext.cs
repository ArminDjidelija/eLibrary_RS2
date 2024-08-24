using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using eLibrary.Model.AutoriDTOs;
using eLibrary.Model.KorisniciDTOs;
using eLibrary.Model.UpitiDTO;
using Microsoft.EntityFrameworkCore;

namespace eLibrary.Services.Database;

public partial class ELibraryContext : DbContext
{
    public ELibraryContext()
    {
    }

    public ELibraryContext(DbContextOptions<ELibraryContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Autori> Autoris { get; set; }

    public virtual DbSet<BibliotekaCitaociZabrane> BibliotekaCitaociZabranes { get; set; }

    public virtual DbSet<BibliotekaKnjige> BibliotekaKnjiges { get; set; }

    public virtual DbSet<BibliotekaUposleni> BibliotekaUposlenis { get; set; }

    public virtual DbSet<Biblioteke> Bibliotekes { get; set; }

    public virtual DbSet<CiljneGrupe> CiljneGrupes { get; set; }

    public virtual DbSet<Citaoci> Citaocis { get; set; }

    public virtual DbSet<Clanarine> Clanarines { get; set; }

    public virtual DbSet<Izdavaci> Izdavacis { get; set; }

    public virtual DbSet<Jezici> Jezicis { get; set; }

    public virtual DbSet<Kantoni> Kantonis { get; set; }

    public virtual DbSet<KnjigaAutori> KnjigaAutoris { get; set; }

    public virtual DbSet<KnjigaCiljneGrupe> KnjigaCiljneGrupes { get; set; }

    public virtual DbSet<KnjigaVrsteSadrzaja> KnjigaVrsteSadrzajas { get; set; }

    public virtual DbSet<Knjige> Knjiges { get; set; }

    public virtual DbSet<Korisnici> Korisnicis { get; set; }

    public virtual DbSet<KorisniciUloge> KorisniciUloges { get; set; }

    public virtual DbSet<KorisnikSacuvanaKnjiga> KorisnikSacuvanaKnjigas { get; set; }

    public virtual DbSet<Obavijesti> Obavijestis { get; set; }

    public virtual DbSet<Penali> Penalis { get; set; }

    public virtual DbSet<Pozajmice> Pozajmices { get; set; }

    public virtual DbSet<ProduzenjePozajmica> ProduzenjePozajmicas { get; set; }

    public virtual DbSet<Rezervacije> Rezervacijes { get; set; }

    //public virtual DbSet<Rukovodilac> Rukovodilacs { get; set; }

    public virtual DbSet<TipClanarineBiblioteke> TipClanarineBibliotekes { get; set; }

    public virtual DbSet<TipoviUplatum> TipoviUplata { get; set; }

    public virtual DbSet<Uloge> Uloges { get; set; }

    public virtual DbSet<Upiti> Upitis { get; set; }

    public virtual DbSet<Uplate> Uplates { get; set; }

    public virtual DbSet<Uvezi> Uvezis { get; set; }

    public virtual DbSet<Valute> Valutes { get; set; }

    public virtual DbSet<VrsteSadrzaja> VrsteSadrzajas { get; set; }

    public virtual DbSet<VrsteGrade> VrsteGrades { get; set; }

    public virtual DbSet<CitalacKnjigaLog> CitalacKnjigaLogs { get; set; }


    //    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    //#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
    //        => optionsBuilder.UseSqlServer("Data Source=localhost, 1433;Initial Catalog=210046;user=sa;Password=QWEasd123!;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        foreach (var entityType in modelBuilder.Model.GetEntityTypes())
        {
            if (typeof(ISoftDeletable).IsAssignableFrom(entityType.ClrType))
            {
                var parameter = Expression.Parameter(entityType.ClrType, "e");
                var filter = Expression.Lambda(Expression.Equal(
                    Expression.Property(parameter, nameof(ISoftDeletable.IsDeleted)),
                    Expression.Constant(false)), parameter);

                modelBuilder.Entity(entityType.ClrType).HasQueryFilter(filter);
            }
        }

        modelBuilder.Entity<Autori>(entity =>
        {
            entity.HasKey(e => e.AutorId).HasName("PK__Autori__F58AE929E28C90E7");

            entity.ToTable("Autori");

            entity.Property(e => e.Ime).HasMaxLength(80);
            entity.Property(e => e.Prezime).HasMaxLength(80);
        });

        modelBuilder.Entity<BibliotekaCitaociZabrane>(entity =>
        {
            entity.HasKey(e => e.BibliotekaCitaocZabranaId).HasName("PK__Bibliote__715D033F62DD5922");

            entity.ToTable("BibliotekaCitaociZabrane");

            entity.Property(e => e.RokZabrane).HasColumnType("datetime");

            entity.HasOne(d => d.Biblioteka).WithMany(p => p.BibliotekaCitaociZabranes)
                .HasForeignKey(d => d.BibliotekaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKBiblioteka338157");

            entity.HasOne(d => d.Citalac).WithMany(p => p.BibliotekaCitaociZabranes)
                .HasForeignKey(d => d.CitalacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKBiblioteka377889");
        });

        modelBuilder.Entity<BibliotekaKnjige>(entity =>
        {
            entity.HasKey(e => e.BibliotekaKnjigaId).HasName("PK__Bibliote__1B347E4186C1376E");

            entity.ToTable("BibliotekaKnjige");

            entity.Property(e => e.DatumDodavanja).HasColumnType("datetime");
            entity.Property(e => e.Lokacija).HasMaxLength(30);

            entity.HasOne(d => d.Biblioteka).WithMany(p => p.BibliotekaKnjiges)
                .HasForeignKey(d => d.BibliotekaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKBiblioteka353465");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.BibliotekaKnjiges)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKBiblioteka650765");
        });

        modelBuilder.Entity<BibliotekaUposleni>(entity =>
        {
            entity.HasKey(e => e.BibliotekaUposleniId).HasName("PK__Bibliote__304DBEB3A7395A71");

            entity.ToTable("BibliotekaUposleni");

            entity.Property(e => e.DatumUposlenja).HasColumnType("datetime");

            entity.HasOne(d => d.Biblioteka).WithMany(p => p.BibliotekaUposlenis)
                .HasForeignKey(d => d.BibliotekaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKBiblioteka763883");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.BibliotekaUposlenis)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKBiblioteka995992");
        });

        modelBuilder.Entity<Biblioteke>(entity =>
        {
            entity.HasKey(e => e.BibliotekaId).HasName("PK__Bibliote__369560083A40BDAF");

            entity.ToTable("Biblioteke");

            entity.Property(e => e.Adresa).HasMaxLength(255);
            entity.Property(e => e.Mail).HasMaxLength(100);
            entity.Property(e => e.Naziv).HasMaxLength(255);
            entity.Property(e => e.Opis).HasMaxLength(1000);
            entity.Property(e => e.Telefon).HasMaxLength(50);
            entity.Property(e => e.Web).HasMaxLength(150);

            entity.HasOne(d => d.Kanton).WithMany(p => p.Bibliotekes)
                .HasForeignKey(d => d.KantonId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKBiblioteke432909");

            //entity.HasOne(d => d.Rukovodilac).WithMany(p => p.Bibliotekes)
            //    .HasForeignKey(d => d.RukovodilacId)
            //    .HasConstraintName("FKBiblioteke215719");
        });

        modelBuilder.Entity<CiljneGrupe>(entity =>
        {
            entity.HasKey(e => e.CiljnaGrupaId).HasName("PK__CiljneGr__98C6319855A6FEAB");

            entity.ToTable("CiljneGrupe");

            entity.Property(e => e.Naziv).HasMaxLength(255);
        });

        modelBuilder.Entity<Citaoci>(entity =>
        {
            entity.HasKey(e => e.CitalacId).HasName("PK__Citaoci__45A5BCBDC7258AF3");

            entity.ToTable("Citaoci");

            entity.Property(e => e.DatumRegistracije).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(255);
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.Institucija).HasMaxLength(150);
            entity.Property(e => e.KorisnickoIme).HasMaxLength(80);
            entity.Property(e => e.LozinkaHash).HasMaxLength(255);
            entity.Property(e => e.LozinkaSalt).HasMaxLength(255);
            entity.Property(e => e.Prezime).HasMaxLength(50);
            entity.Property(e => e.Telefon).HasMaxLength(30);

            entity.HasOne(d => d.Kanton).WithMany(p => p.Citaocis)
                .HasForeignKey(d => d.KantonId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKCitaoci7210");
        });

        modelBuilder.Entity<Clanarine>(entity =>
        {
            entity.HasKey(e => e.ClanarinaId).HasName("PK__Clanarin__C51E3B97E16AE754");

            entity.ToTable("Clanarine");

            entity.Property(e => e.Iznos).HasColumnType("decimal(19, 2)");
            entity.Property(e => e.Kraj).HasColumnType("datetime");
            entity.Property(e => e.Pocetak).HasColumnType("datetime");

            entity.HasOne(d => d.Biblioteka).WithMany(p => p.Clanarines)
                .HasForeignKey(d => d.BibliotekaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKClanarine35451");

            entity.HasOne(d => d.Citalac).WithMany(p => p.Clanarines)
                .HasForeignKey(d => d.CitalacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKClanarine4281");

            entity.HasOne(d => d.TipClanarineBiblioteka).WithMany(p => p.Clanarines)
                .HasForeignKey(d => d.TipClanarineBibliotekaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKClanarine627290");

            entity.HasOne(d => d.Uplate).WithMany(p => p.Clanarines)
                .HasForeignKey(d => d.UplateId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKClanarine777383");
        });

        modelBuilder.Entity<Izdavaci>(entity =>
        {
            entity.HasKey(e => e.IzdavacId).HasName("PK__Izdavaci__6D80AC10BA28287F");

            entity.ToTable("Izdavaci");

            entity.Property(e => e.Naziv).HasMaxLength(255);
        });

        modelBuilder.Entity<Jezici>(entity =>
        {
            entity.HasKey(e => e.JezikId).HasName("PK__Jezici__E9261E091F9E1639");

            entity.ToTable("Jezici");

            entity.Property(e => e.Naziv).HasMaxLength(100);
        });

        modelBuilder.Entity<Kantoni>(entity =>
        {
            entity.HasKey(e => e.KantonId).HasName("PK__Kantoni__F1D12B6139ED8790");

            entity.ToTable("Kantoni");

            entity.Property(e => e.Naziv).HasMaxLength(255);
            entity.Property(e => e.Skracenica).HasMaxLength(50);
        });

        modelBuilder.Entity<KnjigaAutori>(entity =>
        {
            entity.HasKey(e => e.KnjigaAutorId).HasName("PK__KnjigaAu__7CCCDDD646DBDFE0");

            entity.ToTable("KnjigaAutori");

            entity.HasOne(d => d.Autor).WithMany(p => p.KnjigaAutoris)
                .HasForeignKey(d => d.AutorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKnjigaAuto482123");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.KnjigaAutoris)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKnjigaAuto167960");
        });

        modelBuilder.Entity<KnjigaCiljneGrupe>(entity =>
        {
            entity.HasKey(e => e.KnjigaCiljnaGrupaId).HasName("PK__KnjigaCi__4EFEF21A74FFA6F1");

            entity.ToTable("KnjigaCiljneGrupe");

            entity.HasOne(d => d.CiljnaGrupa).WithMany(p => p.KnjigaCiljneGrupes)
                .HasForeignKey(d => d.CiljnaGrupaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKnjigaCilj190689");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.KnjigaCiljneGrupes)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKnjigaCilj768005");
        });

        modelBuilder.Entity<KnjigaVrsteSadrzaja>(entity =>
        {
            entity.HasKey(e => e.KnjigaVrstaSadrzajaId).HasName("PK__KnjigaVr__1CC05BC6BF4EB248");

            entity.ToTable("KnjigaVrsteSadrzaja");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.KnjigaVrsteSadrzajas)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKnjigaVrst688589");

            entity.HasOne(d => d.VrstaSadrzaja).WithMany(p => p.KnjigaVrsteSadrzajas)
                .HasForeignKey(d => d.VrstaSadrzajaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKnjigaVrst124097");
        });

        modelBuilder.Entity<Knjige>(entity =>
        {
            entity.HasKey(e => e.KnjigaId).HasName("PK__Knjige__4A1281F3D12ED027");

            entity.ToTable("Knjige");

            entity.Property(e => e.Isbn).HasMaxLength(30);
            entity.Property(e => e.Napomena).HasMaxLength(1000);
            entity.Property(e => e.Naslov).HasMaxLength(255);

            entity.HasOne(d => d.Izdavac).WithMany(p => p.Knjiges)
                .HasForeignKey(d => d.IzdavacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKnjige283606");

            entity.HasOne(d => d.Jezik).WithMany(p => p.Knjiges)
                .HasForeignKey(d => d.JezikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKnjige125291");

            entity.HasOne(d => d.Uvez).WithMany(p => p.Knjiges)
                .HasForeignKey(d => d.UvezId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKnjige620887");

            entity.HasOne(d => d.VrstaGrade).WithMany(p => p.Knjiges)
                .HasForeignKey(d => d.VrsteGradeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Knjige_VrsteGrade");
        });

        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnic__80B06D411FF047A1");

            entity.ToTable("Korisnici");

            entity.Property(e => e.Email).HasMaxLength(255);
            entity.Property(e => e.Ime).HasMaxLength(80);
            entity.Property(e => e.KorisnickoIme).HasMaxLength(80);
            entity.Property(e => e.LozinkaHash).HasMaxLength(255);
            entity.Property(e => e.LozinkaSalt).HasMaxLength(255);
            entity.Property(e => e.Prezime).HasMaxLength(80);
            entity.Property(e => e.Telefon).HasMaxLength(30);
        });

        modelBuilder.Entity<KorisniciUloge>(entity =>
        {
            entity.HasKey(e => e.KorisnikUlogaId).HasName("PK__Korisnic__1608726E3384F37A");

            entity.ToTable("KorisniciUloge");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.KorisniciUloges)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKorisniciU569719");

            entity.HasOne(d => d.Uloga).WithMany(p => p.KorisniciUloges)
                .HasForeignKey(d => d.UlogaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKorisniciU863268");
        });

        modelBuilder.Entity<KorisnikSacuvanaKnjiga>(entity =>
        {
            entity.HasKey(e => e.KorisnikSacuvanaKnjigaId).HasName("PK__Korisnik__62EEAC2DF4451BD5");

            entity.ToTable("KorisnikSacuvanaKnjiga");

            entity.HasOne(d => d.Citalac).WithMany(p => p.KorisnikSacuvanaKnjigas)
                .HasForeignKey(d => d.CitalacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKorisnikSa44095");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.KorisnikSacuvanaKnjigas)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKorisnikSa920403");
        });

        modelBuilder.Entity<Obavijesti>(entity =>
        {
            entity.HasKey(e => e.ObavijestId).HasName("PK__Obavijes__99D330E047910E09");

            entity.ToTable("Obavijesti");

            entity.Property(e => e.Datum).HasColumnType("datetime");
            entity.Property(e => e.Naslov).HasMaxLength(255);
            entity.Property(e => e.Tekst).HasMaxLength(1000);

            entity.HasOne(d => d.Biblioteka).WithMany(p => p.Obavijestis)
                .HasForeignKey(d => d.BibliotekaId)
                .HasConstraintName("FKObavijesti206190");

            entity.HasOne(d => d.Citalac).WithMany(p => p.Obavijestis)
                .HasForeignKey(d => d.CitalacId)
                .HasConstraintName("FKObavijesti245922");
        });

        modelBuilder.Entity<Penali>(entity =>
        {
            entity.HasKey(e => e.PenalId).HasName("PK__Penali__CE46DA9C31EE0FBA");

            entity.ToTable("Penali");

            entity.Property(e => e.Iznos).HasColumnType("decimal(19, 2)");
            entity.Property(e => e.Opis).HasMaxLength(500);

            entity.HasOne(d => d.Pozajmica).WithMany(p => p.Penalis)
                .HasForeignKey(d => d.PozajmicaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKPenali769294");

            entity.HasOne(d => d.Uplata).WithMany(p => p.Penalis)
                .HasForeignKey(d => d.UplataId)
                .HasConstraintName("FKPenali189592");
        });

        modelBuilder.Entity<Pozajmice>(entity =>
        {
            entity.HasKey(e => e.PozajmicaId).HasName("PK__Pozajmic__7F2251F1A78DEC0B");

            entity.ToTable("Pozajmice");

            entity.Property(e => e.DatumPreuzimanja).HasColumnType("datetime");
            entity.Property(e => e.PreporuceniDatumVracanja).HasColumnType("datetime");
            entity.Property(e => e.StvarniDatumVracanja).HasColumnType("datetime");

            entity.HasOne(d => d.BibliotekaKnjiga).WithMany(p => p.Pozajmices)
                .HasForeignKey(d => d.BibliotekaKnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKPozajmice338406");

            entity.HasOne(d => d.Citalac).WithMany(p => p.Pozajmices)
                .HasForeignKey(d => d.CitalacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKPozajmice865313");
        });

        modelBuilder.Entity<ProduzenjePozajmica>(entity =>
        {
            entity.HasKey(e => e.ProduzenjePozajmiceId).HasName("PK__Produžen__9B28C15E79BEC522");

            entity.ToTable("ProduzenjePozajmica");

            entity.Property(e => e.DatumZahtjeva).HasColumnType("datetime");
            entity.Property(e => e.NoviRok).HasColumnType("datetime");

            entity.HasOne(d => d.Pozajmica).WithMany(p => p.ProduzenjePozajmicas)
                .HasForeignKey(d => d.PozajmicaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKProduženje639386");
        });

        modelBuilder.Entity<Rezervacije>(entity =>
        {
            entity.HasKey(e => e.RezervacijaId).HasName("PK__Rezervac__CABA44DDF2AB12E6");

            entity.ToTable("Rezervacije");

            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.RokRezervacije).HasColumnType("datetime");

            entity.HasOne(d => d.BibliotekaKnjiga).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.BibliotekaKnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRezervacij817101");

            entity.HasOne(d => d.Citalac).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.CitalacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRezervacij386618");
        });

        //modelBuilder.Entity<Rukovodilac>(entity =>
        //{
        //    entity.HasKey(e => e.RukovodilacId).HasName("PK__Rukovodi__E39449BE8CC81700");

        //    entity.ToTable("Rukovodilac");

        //    entity.Property(e => e.Email).HasMaxLength(150);
        //    entity.Property(e => e.Ime).HasMaxLength(50);
        //    entity.Property(e => e.Kontakt).HasMaxLength(50);
        //    entity.Property(e => e.Prezime).HasMaxLength(50);
        //});

        modelBuilder.Entity<TipClanarineBiblioteke>(entity =>
        {
            entity.HasKey(e => e.TipClanarineBibliotekaId).HasName("PK__TipClana__4558C5A1507579E8");

            entity.ToTable("TipClanarineBiblioteke");

            entity.Property(e => e.Iznos).HasColumnType("decimal(19, 2)");
            entity.Property(e => e.Naziv).HasMaxLength(64);

            entity.HasOne(d => d.Biblioteka).WithMany(p => p.TipClanarineBibliotekes)
                .HasForeignKey(d => d.BibliotekaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKTipClanari390390");

            entity.HasOne(d => d.Valuta).WithMany(p => p.TipClanarineBibliotekes)
                .HasForeignKey(d => d.ValutaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKTipClanari83073");
        });

        modelBuilder.Entity<TipoviUplatum>(entity =>
        {
            entity.HasKey(e => e.TipUplateId).HasName("PK__TipoviUp__8E02EB6724A00276");

            entity.Property(e => e.Naziv).HasMaxLength(50);
        });

        modelBuilder.Entity<Uloge>(entity =>
        {
            entity.HasKey(e => e.UlogaId).HasName("PK__Uloge__DCAB23CB2BD0FE6F");

            entity.ToTable("Uloge");

            entity.Property(e => e.Naziv).HasMaxLength(100);
        });

        modelBuilder.Entity<Upiti>(entity =>
        {
            entity.HasKey(e => e.UpitId).HasName("PK__Upiti__EF8C101287181849");

            entity.ToTable("Upiti");

            entity.Property(e => e.Naslov).HasMaxLength(255);
            entity.Property(e => e.Odgovor).HasMaxLength(1000);
            entity.Property(e => e.Upit).HasMaxLength(1000);

            entity.HasOne(d => d.Citalac).WithMany(p => p.Upitis)
                .HasForeignKey(d => d.CitalacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUpiti447286");
        });

        modelBuilder.Entity<Uplate>(entity =>
        {
            entity.HasKey(e => e.UplataId).HasName("PK__Uplate__C5B165E60EBF952A");

            entity.ToTable("Uplate");

            entity.Property(e => e.DatumUplate).HasColumnType("datetime");
            entity.Property(e => e.Iznos).HasColumnType("decimal(19, 2)");

            entity.HasOne(d => d.Biblioteka).WithMany(p => p.Uplates)
                .HasForeignKey(d => d.BibliotekaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUplate801485");

            entity.HasOne(d => d.Citalac).WithMany(p => p.Uplates)
                .HasForeignKey(d => d.CitalacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUplate841217");

            entity.HasOne(d => d.TipUplate).WithMany(p => p.Uplates)
                .HasForeignKey(d => d.TipUplateId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUplate728453");

            entity.HasOne(d => d.Valuta).WithMany(p => p.Uplates)
                .HasForeignKey(d => d.ValutaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUplate862787");
        });

        modelBuilder.Entity<Uvezi>(entity =>
        {
            entity.HasKey(e => e.UvezId).HasName("PK__Uvezi__C4713756A3F9E717");

            entity.ToTable("Uvezi");

            entity.Property(e => e.Naziv).HasMaxLength(100);
        });

        modelBuilder.Entity<Valute>(entity =>
        {
            entity.HasKey(e => e.ValutaId).HasName("PK__Valute__40CFDB4E5F926FDA");

            entity.ToTable("Valute");

            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.Skracenica).HasMaxLength(20);
        });

        modelBuilder.Entity<VrsteSadrzaja>(entity =>
        {
            entity.HasKey(e => e.VrstaSadrzajaId).HasName("PK__VrsteSad__0499598C353505B0");

            entity.ToTable("VrsteSadrzaja");

            entity.Property(e => e.Naziv).HasMaxLength(255);
        });

        modelBuilder.Entity<VrsteGrade>(entity =>
        {
            entity.HasKey(e => e.VrstaGradeId).HasName("PK__VrsteGra__D25BAB10DD033220");

            entity.ToTable("VrsteGrade");

            entity.Property(e => e.Naziv).HasMaxLength(100);
        });

        try
        {
            Console.WriteLine("Seed podataka");
            modelBuilder.Seed();
        } catch (Exception ex)
        {
            Console.WriteLine("Greška");
        }
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}


public static class ModelBuilderExtensions
{
    public static void Seed(this ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Database.Autori>().HasData(
            new Database.Autori { AutorId = 1, Ime = "Leo", Prezime = "Tolstoj", GodinaRodjenja = 1828 },
            new Database.Autori { AutorId = 2, Ime = "Ernest", Prezime = "Hemingway", GodinaRodjenja = 1899 },
            new Database.Autori { AutorId = 3, Ime = "Franz", Prezime = "Kafka", GodinaRodjenja = 1883 },
            new Database.Autori { AutorId = 4, Ime = "Sergej", Prezime = "Jesenjin", GodinaRodjenja = 1895 },
            new Database.Autori { AutorId = 5, Ime = "Alexander", Prezime = "Pushkin", GodinaRodjenja = 1799 },
            new Database.Autori { AutorId = 6, Ime = "Fjodor", Prezime = "Dostojevski", GodinaRodjenja = 1821 },
            new Database.Autori { AutorId = 7, Ime = "George", Prezime = "Orwell", GodinaRodjenja = 1903 },
            new Database.Autori { AutorId = 8, Ime = "Mark", Prezime = "Twain", GodinaRodjenja = 1835 },
            new Database.Autori { AutorId = 9, Ime = "Charles", Prezime = "Dickens", GodinaRodjenja = 1845 },
            new Database.Autori { AutorId = 10, Ime = "Jules", Prezime = "Verne", GodinaRodjenja = 1828 },
            new Database.Autori { AutorId = 11, Ime = "Meša", Prezime = "Selimović", GodinaRodjenja = 1910 },
            new Database.Autori { AutorId = 12, Ime = "Feđa", Prezime = "Štukan", GodinaRodjenja = 1974 }
        );


        modelBuilder.Entity<Database.CiljneGrupe>().HasData(
   new Database.CiljneGrupe { CiljnaGrupaId = 1, Naziv = "Odrasli >18" },
   new Database.CiljneGrupe { CiljnaGrupaId = 2, Naziv = "Djeca" },
   new Database.CiljneGrupe { CiljnaGrupaId = 3, Naziv = "Ozbiljna" },
   new Database.CiljneGrupe { CiljnaGrupaId = 4, Naziv = "10-14" },
   new Database.CiljneGrupe { CiljnaGrupaId = 5, Naziv = "14-18" },
   new Database.CiljneGrupe { CiljnaGrupaId = 6, Naziv = "Opšte štivo" }
        );
        modelBuilder.Entity<Database.Kantoni>().HasData(
    new Database.Kantoni { KantonId = 1, Naziv = "Unsko-sanski kanton", Skracenica = "USK" },
    new Database.Kantoni { KantonId = 2, Naziv = "Posavski kanton", Skracenica = "PK" },
    new Database.Kantoni { KantonId = 3, Naziv = "Tuzlanski kanton", Skracenica = "TK" },
    new Database.Kantoni { KantonId = 4, Naziv = "Zenicko-dobojski kanton", Skracenica = "ZDK" },
    new Database.Kantoni { KantonId = 5, Naziv = "Bosansko-podrinjski kanton Goražde", Skracenica = "BPK" },
    new Database.Kantoni { KantonId = 6, Naziv = "Srednjobosanski kanton", Skracenica = "SBK" },
    new Database.Kantoni { KantonId = 7, Naziv = "Hercegovacko-neretvanski kanton", Skracenica = "HNK" },
    new Database.Kantoni { KantonId = 8, Naziv = "Zapadnohercegovacki kanton", Skracenica = "ZHK" },
    new Database.Kantoni { KantonId = 9, Naziv = "Kanton Sarajevo", Skracenica = "KS" },
    new Database.Kantoni { KantonId = 10, Naziv = "Kanton 10", Skracenica = "K10" }
        );

        modelBuilder.Entity<Database.VrsteSadrzaja>().HasData(
new Database.VrsteSadrzaja { VrstaSadrzajaId = 1, Naziv = "Roman" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 2, Naziv = "Poezija" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 3, Naziv = "Fantastika" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 4, Naziv = "Putopis" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 5, Naziv = "Kriminalistika" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 6, Naziv = "Ljubavni roman" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 7, Naziv = "Triler" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 8, Naziv = "Vestern" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 9, Naziv = "Modernizam" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 10, Naziv = "Pustolovni roman" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 11, Naziv = "Naucna fantastika" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 12, Naziv = "Doktorski rad" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 13, Naziv = "Diplomski rad" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 14, Naziv = "Magistarski rad" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 15, Naziv = "Stručni rad" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 16, Naziv = "Udžbenik" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 17, Naziv = "Tehnički izvještaj" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 18, Naziv = "Zbornik" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 19, Naziv = "Rječnik" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 21, Naziv = "Istraživački rad" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 22, Naziv = "Enciklopedija" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 23, Naziv = "Biografija" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 24, Naziv = "Književnost" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 25, Naziv = "Bajka" },
new Database.VrsteSadrzaja { VrstaSadrzajaId = 26, Naziv = "Dječije knjige" }
        );

        modelBuilder.Entity<Database.VrsteGrade>().HasData(
new Database.VrsteGrade { VrstaGradeId = 1, Naziv = "Knjiga" },
new Database.VrsteGrade { VrstaGradeId = 3, Naziv = "Časopis" },
new Database.VrsteGrade { VrstaGradeId = 4, Naziv = "E-Knjiga" },
new Database.VrsteGrade { VrstaGradeId = 5, Naziv = "Audio knjiga" },
new Database.VrsteGrade { VrstaGradeId = 6, Naziv = "Članak" }
        );

        modelBuilder.Entity<Database.Valute>().HasData(
new Database.Valute { ValutaId = 1, Naziv = "Konvertibilna marka", Skracenica = "KM" },
new Database.Valute { ValutaId = 2, Naziv = "Euro", Skracenica = "EUR" }
        );

        modelBuilder.Entity<Database.Uvezi>().HasData(
new Database.Uvezi { UvezId = 1, Naziv = "Mehki" },
new Database.Uvezi { UvezId = 2, Naziv = "Tvrdi" },
new Database.Uvezi { UvezId = 5, Naziv = "Bez uveza" }
        );

        modelBuilder.Entity<Database.Uloge>().HasData(
new Database.Uloge { UlogaId = 1, Naziv = "Bibliotekar" },
new Database.Uloge { UlogaId = 2, Naziv = "Administrator" },
new Database.Uloge { UlogaId = 3, Naziv = "Menadzer" }
        );

        modelBuilder.Entity<Database.TipoviUplatum>().HasData(
new Database.TipoviUplatum { TipUplateId = 1, Naziv = "Online" },
new Database.TipoviUplatum { TipUplateId = 2, Naziv = "Keš" }
        );

        modelBuilder.Entity<Database.Jezici>().HasData(
new Database.Jezici { JezikId = 1, Naziv = "Bosanski" },
new Database.Jezici { JezikId = 2, Naziv = "Hrvatski" },
new Database.Jezici { JezikId = 3, Naziv = "Srpski" },
new Database.Jezici { JezikId = 4, Naziv = "Engleski" },
new Database.Jezici { JezikId = 5, Naziv = "Crnogorski" },
new Database.Jezici { JezikId = 6, Naziv = "Njemački" },
new Database.Jezici { JezikId = 7, Naziv = "Španski" },
new Database.Jezici { JezikId = 8, Naziv = "Francuski" },
new Database.Jezici { JezikId = 9, Naziv = "Ruski" },
new Database.Jezici { JezikId = 10, Naziv = "Slovenski" },
new Database.Jezici { JezikId = 11, Naziv = "Indijski" }
        );

        modelBuilder.Entity<Database.Izdavaci>().HasData(
new Database.Izdavaci { IzdavacId = 1, Naziv = "BH Most" },
new Database.Izdavaci { IzdavacId = 2, Naziv = "Globus Media" },
new Database.Izdavaci { IzdavacId = 3, Naziv = "Laguna" },
new Database.Izdavaci { IzdavacId = 4, Naziv = "Plato" },
new Database.Izdavaci { IzdavacId = 5, Naziv = "Nova knjiga, Kosmos" },
new Database.Izdavaci { IzdavacId = 6, Naziv = "Rabic" },
new Database.Izdavaci { IzdavacId = 7, Naziv = "Otvorena knjiga" },
new Database.Izdavaci { IzdavacId = 9, Naziv = "Školska knjiga" },
new Database.Izdavaci { IzdavacId = 10, Naziv = "Fakultet informacijskih tehnologija Mostar" },
new Database.Izdavaci { IzdavacId = 11, Naziv = "Građevinski fakultet Mostar" },
new Database.Izdavaci { IzdavacId = 12, Naziv = "Mašinski fakultet Mostar" }
        );

        modelBuilder.Entity<Database.Biblioteke>().HasData(
    new Database.Biblioteke { BibliotekaId = 2, Naziv = "Narodna biblioteka Mostar", Adresa = "Maršala Tita 55", Opis = "Opis biblioteke Narodna Mostar", Web = "www.npm.ba", Telefon = "06456465", Mail = "nbm@mail", KantonId = 7 },
    new Database.Biblioteke { BibliotekaId = 3, Naziv = "Univerzitetska biblioteka Džemal Bijedić", Adresa = "Sjeverni logor, bb", Opis = "Opis biblioteke", Web = "unmo.ba", Telefon = "06456465", Mail = "mail", KantonId = 7 },
    new Database.Biblioteke { BibliotekaId = 4, Naziv = "Univerzitetska biblioteka Sarajevo", Adresa = "Vilsonovo šetalište", Opis = "Opis biblioteke", Web = "www.unbs.ba", Telefon = "789789789", Mail = "unbs@gmail.com", KantonId = 9 }
);

        modelBuilder.Entity<Database.Citaoci>().HasData(
    new Database.Citaoci
    {
        CitalacId = 1,
        Ime = "Nedim",
        Prezime = "Mustafić",
        Email = "nedim@gmail.com",
        Telefon = "06060606",
        KorisnickoIme = "nedim",
        LozinkaHash = "qRhawiSrna2wYUJ2X409WTLVcFE=",
        LozinkaSalt = "OKjxuh/R+pAdr7OZJxbaPw==",
        Status = true,
        Institucija = "Fakultet informacijskih tehnologija",
        DatumRegistracije = DateTime.Parse("2024-07-20 14:48:41.913"),
        KantonId = 4
    },
    new Database.Citaoci
    {
        CitalacId = 2,
        Ime = "Ensar",
        Prezime = "Čevra",
        Email = "ensar@gmail.com",
        Telefon = "06245645645665",
        KorisnickoIme = "ensar",
        LozinkaHash = "pPHFEdB0fs1jkY7nIIhSOz95gO4=",
        LozinkaSalt = "B7vl9rToyYXnfW93niHFeA==",
        Status = true,
        Institucija = "Fakultet informacijskih tehnologija",
        DatumRegistracije = DateTime.Parse("2024-07-20 14:50:48.380"),
        KantonId = 7
    },
    new Database.Citaoci
    {
        CitalacId = 3,
        Ime = "Adnan",
        Prezime = "Humačkić",
        Email = "adnan@gmail.com",
        Telefon = "06245645645665",
        KorisnickoIme = "adnan",
        LozinkaHash = "bCjZ1m2TOG0riBnuKnVldry0WIw=",
        LozinkaSalt = "rBc/mOO5FGenmnDJknziLQ==",
        Status = true,
        Institucija = "Fakultet informacijskih tehnologija",
        DatumRegistracije = DateTime.Parse("2024-07-20 14:51:37.137"),
        KantonId = 10
    },
    new Database.Citaoci
    {
        CitalacId = 4,
        Ime = "Armina",
        Prezime = "Kukrica",
        Email = "armina@gmail.com",
        Telefon = "06245645645665",
        KorisnickoIme = "armina",
        LozinkaHash = "8D7RuSseoVrZqMHnluIGI35IEB0=",
        LozinkaSalt = "u5ryQL32st+ka2ZdvE0c+Q==",
        Status = true,
        Institucija = "Fakultet informacijskih tehnologija",
        DatumRegistracije = DateTime.Parse("2024-07-20 14:51:57.743"),
        KantonId = 7
    },
    new Database.Citaoci
    {
        CitalacId = 5,
        Ime = "Omar",
        Prezime = "Čolakhodžić",
        Email = "omar@gmail.com",
        Telefon = "123456789",
        KorisnickoIme = "omar",
        LozinkaHash = "ARDDRi6wBmL9WL1rjUM2saWZ8xs=",
        LozinkaSalt = "cZSWSeV7I6VLubSRJqk24w==",
        Status = true,
        Institucija = "Fakultet informacijskih tehnologija Mostar",
        DatumRegistracije = DateTime.Parse("2024-07-27 00:21:44.000"),
        KantonId = 7
    });

        modelBuilder.Entity<Database.Korisnici>().HasData(
        new Database.Korisnici
        {
            KorisnikId = 1,
            Ime = "Armin",
            Prezime = "Đidelija",
            Email = "administrator@elibrary.ba",
            Telefon = "06060606060606",
            KorisnickoIme = "admin",
            LozinkaHash = "Kx2LXRCues8YMgvZVdPw5Sog6AY=",
            LozinkaSalt = "Mze6gFYvmgrOG8urSD+mhg==",
            Status = true,
            IsDeleted = false,
            VrijemeBrisanja = null
        },
        new Database.Korisnici
        {
            KorisnikId = 2,
            Ime = "Sadzida",
            Prezime = "Dziho",
            Email = "sadzida@gmail.com",
            Telefon = "123456",
            KorisnickoIme = "sadzida",
            LozinkaHash = "IJkGlOqAg/rO4d5XZNZANcE+oB0=",
            LozinkaSalt = "hQUHyw2/xOR9SgSrzImM5g==",
            Status = true,
            IsDeleted = false,
            VrijemeBrisanja = null
        },
        new Database.Korisnici
        {
            KorisnikId = 3,
            Ime = "Zaim",
            Prezime = "Mehic",
            Email = "zaim@gmail.com",
            Telefon = "123456",
            KorisnickoIme = "zaim",
            LozinkaHash = "hTo8O0Tf5Gti0X21sTJcAOXjxHE=",
            LozinkaSalt = "dgCBLLURssjdW6U+61MC+Q==",
            Status = true,
            IsDeleted = false,
            VrijemeBrisanja = null
        },
        new Database.Korisnici
        {
            KorisnikId = 4,
            Ime = "armina",
            Prezime = "kukrica",
            Email = "armina@gmail.com",
            Telefon = "123456",
            KorisnickoIme = "armina.kukrica",
            LozinkaHash = "yqQNeXOd4XocaafqiB+59dvWYbs=",
            LozinkaSalt = "rHFL2A0lqS3itvCiuRyhVg==",
            Status = true,
            IsDeleted = false,
            VrijemeBrisanja = null
        },
        new Database.Korisnici
        {
            KorisnikId = 5,
            Ime = "armina",
            Prezime = "kukrica",
            Email = "armina@gmail.com",
            Telefon = "123456",
            KorisnickoIme = "armina.kukrica",
            LozinkaHash = "VYY4BksWLWbNSdO9XZYdwPUFLzk=",
            LozinkaSalt = "BxKdmowDCc5jl8GyLj+n4w==",
            Status = true,
            IsDeleted = true,
            VrijemeBrisanja = DateTime.Parse("2024-08-11 13:06:29.1313135")
        },
        new Database.Korisnici
        {
            KorisnikId = 6,
            Ime = "Menadzer",
            Prezime = "Prezime",
            Email = "menadzer@gmail.com",
            Telefon = "062109192",
            KorisnickoIme = "menadzer",
            LozinkaHash = "cC+io0VNs0yfz9Tm+++kOaTx0Fo=",
            LozinkaSalt = "kKZ2nUKX6yke8yMCQBWaSg==",
            Status = true,
            IsDeleted = false,
            VrijemeBrisanja = null
        },
        new Database.Korisnici
        {
            KorisnikId = 7,
            Ime = "Menadzer",
            Prezime = "Prezime",
            Email = "menadzer@gmail.com",
            Telefon = "065168468",
            KorisnickoIme = "sjeverni",
            LozinkaHash = "MDBkR0P1YzZv1Vn5b1oWrQiHYws=",
            LozinkaSalt = "e+1Vf6DBobsBHoJe5qDqFw==",
            Status = true,
            IsDeleted = true,
            VrijemeBrisanja = DateTime.Parse("2024-08-11 13:05:32.1668117")
        },
        new Database.Korisnici
        {
            KorisnikId = 8,
            Ime = "Osman",
            Prezime = "Hadzikic",
            Email = "osman@gmail.com",
            Telefon = "0656565",
            KorisnickoIme = "osman",
            LozinkaHash = "oDWoyvj7xIqrF1W+4BRF3nhAzfI=",
            LozinkaSalt = "XsrX8H2nlXkhwTVnEHt5TA==",
            Status = true,
            IsDeleted = true,
            VrijemeBrisanja = DateTime.Parse("2024-08-11 21:41:30.7786302")
        },
        new Database.Korisnici
        {
            KorisnikId = 9,
            Ime = "novi",
            Prezime = "prezime",
            Email = "mail@mail.com",
            Telefon = "123456",
            KorisnickoIme = "novi",
            LozinkaHash = "6QprCbiUAp7PpqZE9C3WQRIJzOE=",
            LozinkaSalt = "0DlJBwyQAYwRuA5X92t3rw==",
            Status = true,
            IsDeleted = true,
            VrijemeBrisanja = DateTime.Parse("2024-08-11 21:42:14.6254696")
        },
        new Database.Korisnici
        {
            KorisnikId = 10,
            Ime = "armin",
            Prezime = "dido",
            Email = "didelija.armin@gmail.com",
            Telefon = "telefon",
            KorisnickoIme = "djido",
            LozinkaHash = "RQc+vqwpRtGqt5PJWNxlSCMW7F4=",
            LozinkaSalt = "RKHTT6eMngdXoWnlkJgeNA==",
            Status = true,
            IsDeleted = false,
            VrijemeBrisanja = null
        },
        new Database.Korisnici
        {
            KorisnikId = 11,
            Ime = "armin",
            Prezime = "dido",
            Email = "didelija.armin@gmail.com",
            Telefon = "telefon",
            KorisnickoIme = "djidoo",
            LozinkaHash = "XzUrBzqHdihkHSoLsItCv/VbKIU=",
            LozinkaSalt = "XQMWbwIwvsMs5MMBfaU6qw==",
            Status = true,
            IsDeleted = false,
            VrijemeBrisanja = null
        }
        );

        modelBuilder.Entity<Uplate>().HasData(
    new Uplate
    {
        UplataId = 3,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 4.00m,
        DatumUplate = DateTime.Parse("2024-07-28 17:18:26.167"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 4,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 4.00m,
        DatumUplate = DateTime.Parse("2024-07-28 19:20:56.727"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 5,
        CitalacId = 3,
        BibliotekaId = 2,
        Iznos = 4.00m,
        DatumUplate = DateTime.Parse("2024-08-17 19:14:37.383"),
        TipUplateId = 2,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 6,
        CitalacId = 3,
        BibliotekaId = 2,
        Iznos = 10.00m,
        DatumUplate = DateTime.Parse("2024-08-17 19:15:54.627"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 11,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 5.00m,
        DatumUplate = DateTime.Parse("2024-08-17 20:57:06.493"),
        TipUplateId = 2,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 12,
        CitalacId = 3,
        BibliotekaId = 2,
        Iznos = 5.00m,
        DatumUplate = DateTime.Parse("2024-08-17 21:11:07.467"),
        TipUplateId = 2,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 13,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 5.00m,
        DatumUplate = DateTime.Parse("2024-08-17 21:11:21.040"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 14,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 20.00m,
        DatumUplate = DateTime.Parse("2024-08-17 21:11:24.153"),
        TipUplateId = 2,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 15,
        CitalacId = 3,
        BibliotekaId = 2,
        Iznos = 5.00m,
        DatumUplate = DateTime.Parse("2024-08-17 21:11:36.797"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 16,
        CitalacId = 5,
        BibliotekaId = 2,
        Iznos = 15.00m,
        DatumUplate = DateTime.Parse("2024-08-17 21:36:13.257"),
        TipUplateId = 2,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 17,
        CitalacId = 4,
        BibliotekaId = 2,
        Iznos = 4.00m,
        DatumUplate = DateTime.Parse("2024-08-20 19:56:11.080"),
        TipUplateId = 2,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 18,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 5.00m,
        DatumUplate = DateTime.Parse("2024-08-20 20:11:44.707"),
        TipUplateId = 2,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 19,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 4.00m,
        DatumUplate = DateTime.Parse("2024-08-21 20:12:48.320"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 20,
        CitalacId = 3,
        BibliotekaId = 3,
        Iznos = 5.00m,
        DatumUplate = DateTime.Parse("2024-08-21 20:17:27.793"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 21,
        CitalacId = 3,
        BibliotekaId = 3,
        Iznos = 30.00m,
        DatumUplate = DateTime.Parse("2024-08-21 20:19:00.583"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 22,
        CitalacId = 1,
        BibliotekaId = 3,
        Iznos = 30.00m,
        DatumUplate = DateTime.Parse("2024-08-21 20:39:43.703"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 23,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 2.00m,
        DatumUplate = DateTime.Parse("2024-08-21 20:40:57.643"),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    }
        );

        modelBuilder.Entity<Upiti>().HasData(
    new Upiti
    {
        UpitId = 1,
        Naslov = "Greška u aplikaciji",
        Upit = "Nakon klika potrebno je nešto napraviti...",
        Odgovor = "Problem će uskoro biti riješennnnn",
        CitalacId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    }
);

        modelBuilder.Entity<TipClanarineBiblioteke>().HasData(
            new TipClanarineBiblioteke
            {
                TipClanarineBibliotekaId = 6,
                Naziv = "Mjesečna",
                Trajanje = 30,
                Iznos = 4.00m,
                BibliotekaId = 2,
                ValutaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new TipClanarineBiblioteke
            {
                TipClanarineBibliotekaId = 7,
                Naziv = "Tromjesečna",
                Trajanje = 90,
                Iznos = 10.00m,
                BibliotekaId = 2,
                ValutaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new TipClanarineBiblioteke
            {
                TipClanarineBibliotekaId = 8,
                Naziv = "Polugodišnja",
                Trajanje = 180,
                Iznos = 15.00m,
                BibliotekaId = 2,
                ValutaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new TipClanarineBiblioteke
            {
                TipClanarineBibliotekaId = 9,
                Naziv = "Godišnja",
                Trajanje = 365,
                Iznos = 20.00m,
                BibliotekaId = 2,
                ValutaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new TipClanarineBiblioteke
            {
                TipClanarineBibliotekaId = 10,
                Naziv = "Mjesečna",
                Trajanje = 30,
                Iznos = 5.00m,
                BibliotekaId = 3,
                ValutaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new TipClanarineBiblioteke
            {
                TipClanarineBibliotekaId = 11,
                Naziv = "Godišnja",
                Trajanje = 365,
                Iznos = 30.00m,
                BibliotekaId = 3,
                ValutaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new TipClanarineBiblioteke
            {
                TipClanarineBibliotekaId = 12,
                Naziv = "Dvogodišnja",
                Trajanje = 730,
                Iznos = 35.00m,
                BibliotekaId = 2,
                ValutaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            }
        );

        modelBuilder.Entity<Rezervacije>().HasData(
    new Rezervacije
    {
        RezervacijaId = 16,
        CitalacId = 2,
        BibliotekaKnjigaId = 12,
        DatumKreiranja = new DateTime(2024, 8, 11, 15, 29, 7, 850),
        Odobreno = true,
        RokRezervacije = new DateTime(2024, 8, 19, 10, 5, 30, 787),
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Ponistena"
    },
    new Rezervacije
    {
        RezervacijaId = 17,
        CitalacId = 2,
        BibliotekaKnjigaId = 12,
        DatumKreiranja = new DateTime(2024, 8, 11, 15, 34, 46, 240),
        Odobreno = true,
        RokRezervacije = new DateTime(2024, 8, 19, 10, 5, 29, 140),
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Ponistena"
    },
    new Rezervacije
    {
        RezervacijaId = 18,
        CitalacId = 1,
        BibliotekaKnjigaId = 12,
        DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
        Odobreno = true,
        RokRezervacije = new DateTime(2024, 8, 19, 10, 5, 27, 263),
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Ponistena"
    },
    new Rezervacije
    {
        RezervacijaId = 19,
        CitalacId = 1,
        BibliotekaKnjigaId = 12,
        DatumKreiranja = new DateTime(2024, 8, 11, 16, 20, 21, 720),
        Odobreno = true,
        RokRezervacije = new DateTime(2024, 8, 18, 13, 11, 24, 200),
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Zavrsena"
    },
    new Rezervacije
    {
        RezervacijaId = 20,
        CitalacId = 1,
        BibliotekaKnjigaId = 12,
        DatumKreiranja = new DateTime(2024, 8, 11, 16, 28, 4, 540),
        Odobreno = true,
        RokRezervacije = new DateTime(2024, 8, 17, 20, 47, 49, 410),
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Zavrsena"
    },
    new Rezervacije
    {
        RezervacijaId = 21,
        CitalacId = 1,
        BibliotekaKnjigaId = 12,
        DatumKreiranja = new DateTime(2024, 8, 11, 17, 38, 31, 480),
        Odobreno = true,
        RokRezervacije = new DateTime(2024, 8, 12, 21, 43, 9, 177),
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Zavrsena"
    },
    new Rezervacije
    {
        RezervacijaId = 22,
        CitalacId = 1,
        BibliotekaKnjigaId = 13,
        DatumKreiranja = new DateTime(2024, 8, 11, 17, 39, 31, 480),
        Odobreno = true,
        RokRezervacije = new DateTime(2024, 8, 12, 18, 38, 3, 653),
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Zavrsena"
    },
    new Rezervacije
    {
        RezervacijaId = 23,
        CitalacId = 1,
        BibliotekaKnjigaId = 15,
        DatumKreiranja = new DateTime(2024, 8, 18, 20, 24, 40, 827),
        Odobreno = true,
        RokRezervacije = new DateTime(2024, 8, 19, 23, 9, 18, 867),
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Ponistena"
    },
    new Rezervacije
    {
        RezervacijaId = 24,
        CitalacId = 1,
        BibliotekaKnjigaId = 15,
        DatumKreiranja = new DateTime(2024, 8, 18, 20, 24, 42, 783),
        Odobreno = true,
        RokRezervacije = new DateTime(2024, 8, 19, 23, 9, 57, 580),
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Zavrsena"
    },
    new Rezervacije
    {
        RezervacijaId = 25,
        CitalacId = 1,
        BibliotekaKnjigaId = 12,
        DatumKreiranja = new DateTime(2024, 8, 19, 18, 4, 28, 773),
        Odobreno = null,
        RokRezervacije = null,
        Ponistena = false,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Kreirana"
    },
    new Rezervacije
    {
        RezervacijaId = 26,
        CitalacId = 1,
        BibliotekaKnjigaId = 22,
        DatumKreiranja = new DateTime(2024, 8, 20, 19, 9, 7, 493),
        Odobreno = null,
        RokRezervacije = null,
        Ponistena = true,
        IsDeleted = false,
        VrijemeBrisanja = null,
        State = "Ponistena"
    }
);

        modelBuilder.Entity<Obavijesti>().HasData(
    new Obavijesti
    {
        ObavijestId = 2,
        BibliotekaId = 2,
        Naslov = "Novi naslovi",
        Tekst = "U našu biblioteku 5.8.2024. stižu novi bestselleri koje ćete moži preuzeti svakog dana u našoj biblioteci.",
        Datum = new DateTime(2024, 8, 4, 17, 6, 34, 513),
        CitalacId = null,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Obavijesti
    {
        ObavijestId = 3,
        BibliotekaId = 2,
        Naslov = "Novi naslovi",
        Tekst = "U našu biblioteku 5.8.2024. stižu novi bestselleri koje ćete moži preuzeti svakog dana u našoj biblioteci.",
        Datum = new DateTime(2024, 8, 4, 17, 8, 3, 270),
        CitalacId = null,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Obavijesti
    {
        ObavijestId = 4,
        BibliotekaId = 2,
        Naslov = "Vracanje pozajmice",
        Tekst = "Prešli ste rok pozajmice, potrebno je istu vratiti u što ranijem roku",
        Datum = new DateTime(2024, 8, 4, 17, 47, 26, 453),
        CitalacId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Obavijesti
    {
        ObavijestId = 35,
        BibliotekaId = 2,
        Naslov = "Obavijest o roku",
        Tekst = "Poštovani,\nVaša pozajmica knjige Starac i more u biblioteci Narodna biblioteka Mostar ističe 10.08.2024 22:44.\nSrdačan pozdrav",
        Datum = new DateTime(2024, 8, 20, 20, 59, 35, 820),
        CitalacId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Obavijesti
    {
        ObavijestId = 36,
        BibliotekaId = 2,
        Naslov = "Obavijest o roku",
        Tekst = "Poštovani,\nVaša pozajmica knjige 105 pjesama u biblioteci Narodna biblioteka Mostar ističe 08.09.2024 21:43.\nSrdačan pozdrav",
        Datum = new DateTime(2024, 8, 20, 21, 9, 16, 460),
        CitalacId = 4,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Obavijesti
    {
        ObavijestId = 37,
        BibliotekaId = 2,
        Naslov = "Obavijest o roku",
        Tekst = "Poštovani,\nVaša pozajmica knjige Starac i more u biblioteci Narodna biblioteka Mostar ističe 30.08.2024 21:41.\nSrdačan pozdrav",
        Datum = new DateTime(2024, 8, 20, 21, 10, 10, 923),
        CitalacId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    }
);

        modelBuilder.Entity<KorisniciUloge>().HasData(
    new KorisniciUloge
    {
        KorisnikUlogaId = 1,
        UlogaId = 2,
        KorisnikId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 2,
        UlogaId = 4,
        KorisnikId = 2,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 3,
        UlogaId = 1,
        KorisnikId = 3,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 4,
        UlogaId = 1,
        KorisnikId = 5,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 5,
        UlogaId = 4,
        KorisnikId = 6,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 6,
        UlogaId = 1,
        KorisnikId = 7,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 7,
        UlogaId = 4,
        KorisnikId = 7,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 8,
        UlogaId = 1,
        KorisnikId = 8,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 9,
        UlogaId = 1,
        KorisnikId = 9,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 10,
        UlogaId = 1,
        KorisnikId = 10,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new KorisniciUloge
    {
        KorisnikUlogaId = 11,
        UlogaId = 1,
        KorisnikId = 11,
        IsDeleted = false,
        VrijemeBrisanja = null
    }
);



    }
}