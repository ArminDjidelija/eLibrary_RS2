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
            new Database.Autori { AutorId = 11, Ime = "Meša", Prezime = "Selimović", GodinaRodjenja = 1910 }
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
new Database.Uvezi { UvezId = 3, Naziv = "Bez uveza" }
        );

        modelBuilder.Entity<Database.Uloge>().HasData(
new Database.Uloge { UlogaId = 1, Naziv = "Bibliotekar" },
new Database.Uloge { UlogaId = 2, Naziv = "Administrator" }
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
        Ime = "Citalac1",
        Prezime = "Citalac1",
        Email = "citalac1@gmail.com",
        Telefon = "06060606",
        KorisnickoIme = "citalac1",
        LozinkaHash = "2pka8gGVbEqAsY4ijeBsTJehv9Y==",
        LozinkaSalt = "dgCBLLURssjdW6U+61MC+Q==",
        Status = true,
        Institucija = "Fakultet informacijskih tehnologija",
        DatumRegistracije = DateTime.Parse("2024-07-20 14:48:41.913"),
        KantonId = 7
    },
    new Database.Citaoci
    {
        CitalacId = 2,
        Ime = "Citalac2",
        Prezime = "Citalac2",
        Email = "citalac2@gmail.com",
        Telefon = "06060606",
        KorisnickoIme = "citalac2",
        LozinkaHash = "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=",
        LozinkaSalt = "dgCBLLURssjdW6U+61MC+Q==",
        Status = true,
        Institucija = "Fakultet informacijskih tehnologija",
        DatumRegistracije = DateTime.Parse("2024-07-20 14:48:41.913"),
        KantonId = 7
    }
   );


        modelBuilder.Entity<Database.Korisnici>().HasData(
        new Database.Korisnici
        {
            KorisnikId = 1,
            Ime = "Admin",
            Prezime = "Admin",
            Email = "admin@elibrary.ba",
            Telefon = "06060606060606",
            KorisnickoIme = "admin",
            LozinkaHash = "c1WzmHn/IfIrmkynZcsLyWHuzqE=",
            LozinkaSalt = "dgCBLLURssjdW6U+61MC+Q==",
            Status = true,
            IsDeleted = false,
            VrijemeBrisanja = null
        },
        new Database.Korisnici
        {
            KorisnikId = 2,
            Ime = "Bibliotekar1",
            Prezime = "Bibliotekar1",
            Email = "bibl1@gmail.com",
            Telefon = "06060606",
            KorisnickoIme = "bibliotekar1",
            LozinkaHash = "9MF7KTZlFft51eQvyTtlgmYQlOs=",
            LozinkaSalt = "dgCBLLURssjdW6U+61MC+Q==",
            Status = true,
            IsDeleted = false,
            VrijemeBrisanja = null
        },
        new Database.Korisnici
        {
            KorisnikId = 3,
            Ime = "Bibliotekar2",
            Prezime = "Bibliotekar2",
            Email = "bibl2@gmail.com",
            Telefon = "06060606",
            KorisnickoIme = "bibliotekar2",
            LozinkaHash = "aK8cml17lpwbriKaVDWacJdixas=",
            LozinkaSalt = "dgCBLLURssjdW6U+61MC+Q==",
            Status = true,
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
               UlogaId = 1,
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
           }
        );

        modelBuilder.Entity<BibliotekaUposleni>().HasData(
            new BibliotekaUposleni
            {
                BibliotekaUposleniId = 1,
                KorisnikId = 2,
                BibliotekaId = 2,
                DatumUposlenja = DateTime.Now
            },
            new BibliotekaUposleni
            {
                BibliotekaUposleniId = 2,
                KorisnikId = 3,
                BibliotekaId = 3,
                DatumUposlenja = DateTime.Now
            }
            );


        modelBuilder.Entity<Knjige>().HasData(
            new Knjige
            {
                KnjigaId = 1,
                Naslov = "Starac i more",
                GodinaIzdanja = 2020,
                BrojIzdanja = 1,
                BrojStranica = 89,
                Isbn = "978-9958-771-38-5",
                Napomena = "",
                Slika = null,
                UvezId = 1,
                JezikId = 1,
                IzdavacId = 1,
                VrsteGradeId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 2,
            Naslov = "Ana Karenjina",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 890,
            Isbn = "978-86-521-3555-4",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 4,
            Naslov = "Rat i mir 1",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 800,
            Isbn = "978-86-521-4508-9",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 5,
            Naslov = "Proces",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 220,
            Isbn = "978-86-447-0687-8",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 6,
            Naslov = "Kapetanova kći",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 123,
            Isbn = "9788663693722",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 7,
            Naslov = "105 pjesama",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 230,
            Isbn = "978-9958-771-38-5",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 8,
            Naslov = "1984",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 267,
            Isbn = "978-86-7674-205-9",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 9,
            Naslov = "Pustolovine Toma Sawyera",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 430,
            Isbn = "978-953-0-60381-3",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 10,
            Naslov = "Put oko svijeta za 80 dana",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 56,
            Isbn = "978-9958-41-300-1",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 13,
            Naslov = "Rat i mir II",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 832,
            Isbn = "978-86-521-4509-6",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 14,
            Naslov = "Zločin i kazna",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 616,
            Isbn = "978-9958-18-142-9",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 15,
            Naslov = "Derviš i smrt",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 418,
            Isbn = "978-9958-29-222-4",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            },
            new Knjige
            {
            KnjigaId = 20,
            Naslov = "Dekameron",
            GodinaIzdanja = 2020,
            BrojIzdanja = 1,
            BrojStranica = 160,
            Isbn = "953-196-904-3",
            Napomena = "",
            Slika = null,
            UvezId = 1,
            JezikId = 1,
            IzdavacId = 1,
            VrsteGradeId = 1,
            IsDeleted = false,
            VrijemeBrisanja = null
            }
            //new Knjige
            //{
            //KnjigaId = 1,
            //Naslov = "Starac i more",
            //GodinaIzdanja = 2020,
            //BrojIzdanja = 1,
            //BrojStranica = 89,
            //Isbn = "978-9958-771-38-5",
            //Napomena = "",
            //Slika = null,
            //UvezId = 1,
            //JezikId = 1,
            //IzdavacId = 1,
            //VrsteGradeId = 1,
            //IsDeleted = false,
            //VrijemeBrisanja = null
            //},
            //new Knjige
            //{
            //KnjigaId = 1,
            //Naslov = "Starac i more",
            //GodinaIzdanja = 2020,
            //BrojIzdanja = 1,
            //BrojStranica = 89,
            //Isbn = "978-9958-771-38-5",
            //Napomena = "",
            //Slika = null,
            //UvezId = 1,
            //JezikId = 1,
            //IzdavacId = 1,
            //VrsteGradeId = 1,
            //IsDeleted = false,
            //VrijemeBrisanja = null
            //}
            );


        modelBuilder.Entity<KnjigaAutori>().HasData(
             new KnjigaAutori
             {
                 KnjigaAutorId = 1,
                 AutorId = 2,
                 KnjigaId = 1,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 2,
                 AutorId = 1,
                 KnjigaId = 2,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 3,
                 AutorId = 1,
                 KnjigaId = 4,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 4,
                 AutorId = 3,
                 KnjigaId = 5
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 5,
                 AutorId = 5,
                 KnjigaId = 6,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 6,
                 AutorId = 4,
                 KnjigaId = 7,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 7,
                 AutorId = 7,
                 KnjigaId = 8,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 8,
                 AutorId = 8,
                 KnjigaId = 9,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 9,
                 AutorId = 10,
                 KnjigaId = 10,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 10,
                 AutorId = 1,
                 KnjigaId = 13,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 11,
                 AutorId = 6,
                 KnjigaId = 14,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 12,
                 AutorId = 11,
                 KnjigaId = 15,
             },
             new KnjigaAutori
             {
                 KnjigaAutorId = 17,
                 AutorId = 13,
                 KnjigaId = 20,
             }
            );

        modelBuilder.Entity<KnjigaCiljneGrupe>().HasData(
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 1,
                CiljnaGrupaId = 1,
                KnjigaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 2,
                CiljnaGrupaId = 2,
                KnjigaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 3,
                CiljnaGrupaId = 1,
                KnjigaId = 2,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 4,
                CiljnaGrupaId = 5,
                KnjigaId = 2,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 5,
                CiljnaGrupaId = 3,
                KnjigaId = 2,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 6,
                CiljnaGrupaId = 6,
                KnjigaId = 4,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 7,
                CiljnaGrupaId = 1,
                KnjigaId = 5,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 8,
                CiljnaGrupaId = 4,
                KnjigaId = 5,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 9,
                CiljnaGrupaId = 5,
                KnjigaId = 5,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 10,
                CiljnaGrupaId = 1,
                KnjigaId = 6,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 11,
                CiljnaGrupaId = 4,
                KnjigaId = 6,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 12,
                CiljnaGrupaId = 15,
                KnjigaId = 6,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 13,
                CiljnaGrupaId = 1,
                KnjigaId = 7,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 14,
                CiljnaGrupaId = 3,
                KnjigaId = 7,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 15,
                CiljnaGrupaId = 1,
                KnjigaId = 8,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 16,
                CiljnaGrupaId = 3,
                KnjigaId = 8,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 17,
                CiljnaGrupaId = 2,
                KnjigaId = 9,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 18,
                CiljnaGrupaId = 6,
                KnjigaId = 9,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 19,
                CiljnaGrupaId = 6,
                KnjigaId = 10,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 20,
                CiljnaGrupaId = 2,
                KnjigaId = 10,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 21,
                CiljnaGrupaId = 1,
                KnjigaId = 13,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 22,
                CiljnaGrupaId = 3,
                KnjigaId = 13,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 23,
                CiljnaGrupaId = 5,
                KnjigaId = 13,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 24,
                CiljnaGrupaId = 5,
                KnjigaId = 14,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 25,
                CiljnaGrupaId = 1,
                KnjigaId = 14,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 26,
                CiljnaGrupaId = 3,
                KnjigaId = 14,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 27,
                CiljnaGrupaId = 5,
                KnjigaId = 15,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new KnjigaCiljneGrupe
            {
                KnjigaCiljnaGrupaId = 28,
                CiljnaGrupaId = 6,
                KnjigaId = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            }
            );

        modelBuilder.Entity<KnjigaVrsteSadrzaja>().HasData(
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 1,
                VrstaSadrzajaId = 1,
                KnjigaId = 1
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 2,
                VrstaSadrzajaId = 1,
                KnjigaId = 2
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 3,
                VrstaSadrzajaId = 24,
                KnjigaId = 2
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 4,
                VrstaSadrzajaId = 1,
                KnjigaId = 4
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 5,
                VrstaSadrzajaId = 24,
                KnjigaId = 4
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 6,
                VrstaSadrzajaId = 1,
                KnjigaId = 5
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 7,
                VrstaSadrzajaId = 24,
                KnjigaId = 5
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 8,
                VrstaSadrzajaId = 1,
                KnjigaId = 6
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 9,
                VrstaSadrzajaId = 24,
                KnjigaId = 6
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 10,
                VrstaSadrzajaId = 2,
                KnjigaId = 7
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 11,
                VrstaSadrzajaId = 24,
                KnjigaId = 7
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 12,
                VrstaSadrzajaId = 1,
                KnjigaId = 8
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 13,
                VrstaSadrzajaId = 24,
                KnjigaId = 8
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 14,
                VrstaSadrzajaId = 25,
                KnjigaId = 9
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 15,
                VrstaSadrzajaId = 26,
                KnjigaId = 9
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 16,
                VrstaSadrzajaId = 1,
                KnjigaId = 10
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 17,
                VrstaSadrzajaId = 26,
                KnjigaId = 10
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 18,
                VrstaSadrzajaId = 1,
                KnjigaId = 13
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 19,
                VrstaSadrzajaId = 24,
                KnjigaId = 13
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 20,
                VrstaSadrzajaId = 1,
                KnjigaId = 14
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 21,
                VrstaSadrzajaId = 24,
                KnjigaId = 14
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 22,
                VrstaSadrzajaId = 1,
                KnjigaId = 15
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 29,
                VrstaSadrzajaId = 1,
                KnjigaId = 20
            },
            new KnjigaVrsteSadrzaja
            {
                KnjigaVrstaSadrzajaId = 30,
                VrstaSadrzajaId = 24,
                KnjigaId = 20
            }
            );


        modelBuilder.Entity<BibliotekaKnjige>().HasData(
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 12,
                BibliotekaId = 2,
                KnjigaId = 1,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 13,
                BibliotekaId = 2,
                KnjigaId = 2,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 15,
                BibliotekaId = 2,
                KnjigaId = 4,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 16,
                BibliotekaId = 2,
                KnjigaId = 7,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 17,
                BibliotekaId = 2,
                KnjigaId = 6,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 18,
                BibliotekaId = 3,
                KnjigaId = 6,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 19,
                BibliotekaId = 3,
                KnjigaId = 4,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 20,
                BibliotekaId = 3,
                KnjigaId = 8,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 21,
                BibliotekaId = 3,
                KnjigaId = 1,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 22,
                BibliotekaId = 3,
                KnjigaId = 10,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 26,
                BibliotekaId = 4,
                KnjigaId = 1,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 27,
                BibliotekaId = 4,
                KnjigaId = 2,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 28,
                BibliotekaId = 4,
                KnjigaId = 5,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new BibliotekaKnjige
            {
                BibliotekaKnjigaId = 29,
                BibliotekaId = 4,
                KnjigaId = 6,
                BrojKopija = 30,
                DatumDodavanja = DateTime.Now,
                Lokacija = "B1",
                DostupnoCitaonica = 25,
                DostupnoPozajmica = 20,
                IsDeleted = false,
                VrijemeBrisanja = null
            }
            );

        modelBuilder.Entity<Pozajmice>().HasData(
            new Pozajmice
            {
                PozajmicaId = 7,
                CitalacId = 1,
                BibliotekaKnjigaId = 12,
                DatumPreuzimanja = DateTime.Now.AddDays(-60),
                PreporuceniDatumVracanja = DateTime.Now.AddDays(-53),
                StvarniDatumVracanja = DateTime.Now.AddDays(-54),
                Trajanje = 7,
                MoguceProduziti = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Pozajmice
            {
                PozajmicaId = 8,
                CitalacId = 1,
                BibliotekaKnjigaId = 15,
                DatumPreuzimanja = DateTime.Now.AddDays(-50),
                PreporuceniDatumVracanja = DateTime.Now.AddDays(-43),
                StvarniDatumVracanja = DateTime.Now.AddDays(-54),
                Trajanje = 7,
                MoguceProduziti = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Pozajmice
            {
                PozajmicaId = 9,
                CitalacId = 1,
                BibliotekaKnjigaId = 16,
                DatumPreuzimanja = DateTime.Now.AddDays(-40),
                PreporuceniDatumVracanja = DateTime.Now.AddDays(-43),
                StvarniDatumVracanja = DateTime.Now.AddDays(-44),
                Trajanje = 7,
                MoguceProduziti = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Pozajmice
            {
                PozajmicaId = 10,
                CitalacId = 2,
                BibliotekaKnjigaId = 12,
                DatumPreuzimanja = DateTime.Now.AddDays(-60),
                PreporuceniDatumVracanja = DateTime.Now.AddDays(-53),
                StvarniDatumVracanja = DateTime.Now.AddDays(-54),
                Trajanje = 7,
                MoguceProduziti = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Pozajmice
            {
                PozajmicaId = 11,
                CitalacId = 2,
                BibliotekaKnjigaId = 13,
                DatumPreuzimanja = DateTime.Now.AddDays(-50),
                PreporuceniDatumVracanja = DateTime.Now.AddDays(-43),
                StvarniDatumVracanja = DateTime.Now.AddDays(-44),
                Trajanje = 7,
                MoguceProduziti = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Pozajmice
            {
                PozajmicaId = 12,
                CitalacId = 2,
                BibliotekaKnjigaId = 12,
                DatumPreuzimanja = DateTime.Now.AddDays(-40),
                PreporuceniDatumVracanja = DateTime.Now.AddDays(-33),
                StvarniDatumVracanja = DateTime.Now.AddDays(-34),
                Trajanje = 7,
                MoguceProduziti = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Pozajmice
            {
                PozajmicaId = 13,
                CitalacId = 1,
                BibliotekaKnjigaId = 12,
                DatumPreuzimanja = DateTime.Now,
                PreporuceniDatumVracanja = DateTime.Now.AddDays(7),
                StvarniDatumVracanja = null,
                Trajanje = 7,
                MoguceProduziti = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Pozajmice
            {
                PozajmicaId = 14,
                CitalacId = 2,
                BibliotekaKnjigaId = 12,
                DatumPreuzimanja = DateTime.Now,
                PreporuceniDatumVracanja = DateTime.Now.AddDays(7),
                StvarniDatumVracanja = null,
                Trajanje = 7,
                MoguceProduziti = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            }
            );

        modelBuilder.Entity<Rezervacije>().HasData(
            new Rezervacije
            {
                RezervacijaId = 1,
                CitalacId =1,
                BibliotekaKnjigaId = 12,
                Odobreno = true,
                RokRezervacije = DateTime.Now,
                Ponistena = true,
                State = "Ponistena",
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Rezervacije
            {
                RezervacijaId = 2,
                CitalacId = 1,
                BibliotekaKnjigaId = 12,
                Odobreno = true,
                RokRezervacije = DateTime.Now,
                Ponistena = true,
                State = "Zavrsena",
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Rezervacije
            {
                RezervacijaId = 3,
                CitalacId = 2,
                BibliotekaKnjigaId = 12,
                Odobreno = true,
                RokRezervacije = DateTime.Now,
                Ponistena = true,
                State = "Ponistena",
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Rezervacije
            {
                RezervacijaId = 4,
                CitalacId = 2,
                BibliotekaKnjigaId = 12,
                Odobreno = true,
                RokRezervacije = DateTime.Now,
                Ponistena = true,
                State = "Zavrsena",
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Rezervacije
            {
                RezervacijaId = 5,
                CitalacId = 1,
                BibliotekaKnjigaId = 12,
                Odobreno = null,
                RokRezervacije = DateTime.Now,
                Ponistena = null,
                State = "Kreirana",
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Rezervacije
            {
                RezervacijaId = 6,
                CitalacId = 2,
                BibliotekaKnjigaId = 12,
                Odobreno = null,
                RokRezervacije = DateTime.Now,
                Ponistena = null,
                State = "Kreirana",
                IsDeleted = false,
                VrijemeBrisanja = null
            }
            );

        modelBuilder.Entity<CitalacKnjigaLog>().HasData(
            new CitalacKnjigaLog
            {
                CitalacKnjigaLogId = 1,
                CitalacId = 1,
                KnjigaId = 1
            },
            new CitalacKnjigaLog
            {
                CitalacKnjigaLogId = 2,
                CitalacId = 1,
                KnjigaId = 2
            },
            new CitalacKnjigaLog
            {
                CitalacKnjigaLogId = 3,
                CitalacId = 2,
                KnjigaId = 5
            },
            new CitalacKnjigaLog
            {
                CitalacKnjigaLogId = 4,
                CitalacId = 2,
                KnjigaId = 6
            }
            );

        modelBuilder.Entity<Uplate>().HasData(
    new Uplate
    {
        UplataId = 1,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 4.00m,
        DatumUplate = DateTime.Now.AddDays(-15),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 2,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 10.00m,
        DatumUplate = DateTime.Now.AddDays(15),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 3,
        CitalacId = 2,
        BibliotekaId = 2,
        Iznos = 4.00m,
        DatumUplate = DateTime.Now.AddDays(-15),
        TipUplateId = 2,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 4,
        CitalacId = 2,
        BibliotekaId = 2,
        Iznos = 10.00m,
        DatumUplate = DateTime.Now.AddDays(15),
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 5,
        CitalacId = 1,
        BibliotekaId = 2,
        Iznos = 10.00m,
        DatumUplate = DateTime.Now,
        TipUplateId = 1,
        ValutaId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    },
    new Uplate
    {
        UplataId = 6,
        CitalacId = 2,
        BibliotekaId = 2,
        Iznos = 10.00m,
        DatumUplate = DateTime.Now,
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
        Odgovor = "Problem će uskoro biti riješen.",
        CitalacId = 1,
        IsDeleted = false,
        VrijemeBrisanja = null
    }
);

        modelBuilder.Entity<KorisnikSacuvanaKnjiga>().HasData(
            new KorisnikSacuvanaKnjiga
            {
                KorisnikSacuvanaKnjigaId = 1,
                CitalacId = 1,
                KnjigaId = 1,
            },
            new KorisnikSacuvanaKnjiga
            {
                KorisnikSacuvanaKnjigaId = 2,
                CitalacId = 1,
                KnjigaId = 4,
            },
            new KorisnikSacuvanaKnjiga
            {
                KorisnikSacuvanaKnjigaId = 3,
                CitalacId = 1,
                KnjigaId = 5,
            },
            new KorisnikSacuvanaKnjiga
            {
                KorisnikSacuvanaKnjigaId = 4,
                CitalacId = 2,
                KnjigaId = 1,
            },
            new KorisnikSacuvanaKnjiga
            {
                KorisnikSacuvanaKnjigaId = 5,
                CitalacId = 2,
                KnjigaId = 5,
            },
            new KorisnikSacuvanaKnjiga
            {
                KorisnikSacuvanaKnjigaId = 6,
                CitalacId = 2,
                KnjigaId = 6,
            }
            );



        modelBuilder.Entity<TipClanarineBiblioteke>().HasData(
            new TipClanarineBiblioteke
            {
                TipClanarineBibliotekaId = 1,
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
                TipClanarineBibliotekaId = 2,
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
                TipClanarineBibliotekaId = 3,
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
                TipClanarineBibliotekaId = 4,
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
                TipClanarineBibliotekaId = 5,
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
                TipClanarineBibliotekaId = 6,
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
                TipClanarineBibliotekaId = 7,
                Naziv = "Godišnja",
                Trajanje = 365,
                Iznos = 35.00m,
                BibliotekaId = 4,
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
    }    
);
        modelBuilder.Entity<Clanarine>().HasData(
            new Clanarine
            {
                ClanarinaId = 1,
                CitalacId = 1,
                BibliotekaId = 2,
                UplateId = 1,
                TipClanarineBibliotekaId = 1,
                Iznos = 4.00m,
                Pocetak = DateTime.Now.AddDays(-15),
                Kraj = DateTime.Now.AddDays(15),
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Clanarine
            {
                ClanarinaId = 2,
                CitalacId = 1,
                BibliotekaId = 2,
                UplateId = 2,
                TipClanarineBibliotekaId = 2,
                Iznos = 10.00m,
                Pocetak = DateTime.Now.AddDays(15),
                Kraj = DateTime.Now.AddDays(105),
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Clanarine
            {
                ClanarinaId = 3,
                CitalacId = 2,
                BibliotekaId = 2,
                UplateId = 3,
                TipClanarineBibliotekaId = 1,
                Iznos = 4.00m,
                Pocetak = DateTime.Now.AddDays(-15),
                Kraj = DateTime.Now.AddDays(15),
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Clanarine
            {
                ClanarinaId = 4,
                CitalacId = 2,
                BibliotekaId = 2,
                UplateId = 4,
                TipClanarineBibliotekaId = 1,
                Iznos = 4.00m,
                Pocetak = DateTime.Now.AddDays(15),
                Kraj = DateTime.Now.AddDays(105),
                IsDeleted = false,
                VrijemeBrisanja = null
            }
            );

        modelBuilder.Entity<Penali>().HasData(
            new Penali
            {
                PenalId = 1,
                PozajmicaId = 7,
                Opis = "Korisnik vratio knjigu sa pocijepanim stranicama",
                UplataId =5,
                Iznos = 10.00m,
                ValutaId = 1,
                IsDeleted= false
            },
            new Penali
            {
                PenalId = 2,
                PozajmicaId = 8,
                Opis = "Korisnik vratio knjigu sa pocijepanim stranicama",
                UplataId = 6,
                Iznos = 10.00m,
                ValutaId = 1,
                IsDeleted = false
            },
            new Penali
            {
                PenalId = 3,
                PozajmicaId = 9,
                Opis = "Korisnik vratio knjigu sa pocijepanim stranicama",
                UplataId = null,
                Iznos = 10.00m,
                ValutaId = 1,
                IsDeleted = false
            }
            );



    }
}