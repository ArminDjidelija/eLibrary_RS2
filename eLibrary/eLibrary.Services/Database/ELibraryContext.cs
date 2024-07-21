using System;
using System.Collections.Generic;
using System.Linq.Expressions;
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

    public virtual DbSet<ProduženjePozajmica> ProduženjePozajmicas { get; set; }

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

        modelBuilder.Entity<ProduženjePozajmica>(entity =>
        {
            entity.HasKey(e => e.ProduzenjePozajmiceId).HasName("PK__Produžen__9B28C15E79BEC522");

            entity.ToTable("ProduženjePozajmica");

            entity.Property(e => e.DatumZahtjeva).HasColumnType("datetime");
            entity.Property(e => e.NoviRok).HasColumnType("datetime");

            entity.HasOne(d => d.Pozajmica).WithMany(p => p.ProduženjePozajmicas)
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

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
