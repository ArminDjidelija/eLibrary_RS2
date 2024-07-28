using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eLibrary.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Autori",
                columns: table => new
                {
                    AutorId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false),
                    GodinaRodjenja = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Autori__F58AE929E28C90E7", x => x.AutorId);
                });

            migrationBuilder.CreateTable(
                name: "CiljneGrupe",
                columns: table => new
                {
                    CiljnaGrupaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__CiljneGr__98C6319855A6FEAB", x => x.CiljnaGrupaId);
                });

            migrationBuilder.CreateTable(
                name: "Izdavaci",
                columns: table => new
                {
                    IzdavacId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Izdavaci__6D80AC10BA28287F", x => x.IzdavacId);
                });

            migrationBuilder.CreateTable(
                name: "Jezici",
                columns: table => new
                {
                    JezikId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Jezici__E9261E091F9E1639", x => x.JezikId);
                });

            migrationBuilder.CreateTable(
                name: "Kantoni",
                columns: table => new
                {
                    KantonId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Skracenica = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Kantoni__F1D12B6139ED8790", x => x.KantonId);
                });

            migrationBuilder.CreateTable(
                name: "Korisnici",
                columns: table => new
                {
                    KorisnikId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Status = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnic__80B06D411FF047A1", x => x.KorisnikId);
                });

            migrationBuilder.CreateTable(
                name: "TipoviUplata",
                columns: table => new
                {
                    TipUplateId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__TipoviUp__8E02EB6724A00276", x => x.TipUplateId);
                });

            migrationBuilder.CreateTable(
                name: "Uloge",
                columns: table => new
                {
                    UlogaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uloge__DCAB23CB2BD0FE6F", x => x.UlogaId);
                });

            migrationBuilder.CreateTable(
                name: "Uvezi",
                columns: table => new
                {
                    UvezId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uvezi__C4713756A3F9E717", x => x.UvezId);
                });

            migrationBuilder.CreateTable(
                name: "Valute",
                columns: table => new
                {
                    ValutaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Skracenica = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Valute__40CFDB4E5F926FDA", x => x.ValutaId);
                });

            migrationBuilder.CreateTable(
                name: "VrsteGrade",
                columns: table => new
                {
                    VrstaGradeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VrsteGra__D25BAB10DD033220", x => x.VrstaGradeId);
                });

            migrationBuilder.CreateTable(
                name: "VrsteSadrzaja",
                columns: table => new
                {
                    VrstaSadrzajaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VrsteSad__0499598C353505B0", x => x.VrstaSadrzajaId);
                });

            migrationBuilder.CreateTable(
                name: "Biblioteke",
                columns: table => new
                {
                    BibliotekaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Adresa = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    Web = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: true),
                    Telefon = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Mail = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    KantonId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Bibliote__369560083A40BDAF", x => x.BibliotekaId);
                    table.ForeignKey(
                        name: "FKBiblioteke432909",
                        column: x => x.KantonId,
                        principalTable: "Kantoni",
                        principalColumn: "KantonId");
                });

            migrationBuilder.CreateTable(
                name: "Citaoci",
                columns: table => new
                {
                    CitalacId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Status = table.Column<bool>(type: "bit", nullable: false),
                    Institucija = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: true),
                    DatumRegistracije = table.Column<DateTime>(type: "datetime", nullable: false),
                    KantonId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Citaoci__45A5BCBDC7258AF3", x => x.CitalacId);
                    table.ForeignKey(
                        name: "FKCitaoci7210",
                        column: x => x.KantonId,
                        principalTable: "Kantoni",
                        principalColumn: "KantonId");
                });

            migrationBuilder.CreateTable(
                name: "KorisniciUloge",
                columns: table => new
                {
                    KorisnikUlogaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UlogaId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnic__1608726E3384F37A", x => x.KorisnikUlogaId);
                    table.ForeignKey(
                        name: "FKKorisniciU569719",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId");
                    table.ForeignKey(
                        name: "FKKorisniciU863268",
                        column: x => x.UlogaId,
                        principalTable: "Uloge",
                        principalColumn: "UlogaId");
                });

            migrationBuilder.CreateTable(
                name: "Knjige",
                columns: table => new
                {
                    KnjigaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    GodinaIzdanja = table.Column<int>(type: "int", nullable: false),
                    BrojIzdanja = table.Column<int>(type: "int", nullable: false),
                    BrojStranica = table.Column<int>(type: "int", nullable: false),
                    Isbn = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: true),
                    Napomena = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    UvezId = table.Column<int>(type: "int", nullable: false),
                    IzdavacId = table.Column<int>(type: "int", nullable: false),
                    VrsteGradeId = table.Column<int>(type: "int", nullable: true),
                    JezikId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Knjige__4A1281F3D12ED027", x => x.KnjigaId);
                    table.ForeignKey(
                        name: "FKKnjige125291",
                        column: x => x.JezikId,
                        principalTable: "Jezici",
                        principalColumn: "JezikId");
                    table.ForeignKey(
                        name: "FKKnjige283606",
                        column: x => x.IzdavacId,
                        principalTable: "Izdavaci",
                        principalColumn: "IzdavacId");
                    table.ForeignKey(
                        name: "FKKnjige620887",
                        column: x => x.UvezId,
                        principalTable: "Uvezi",
                        principalColumn: "UvezId");
                    table.ForeignKey(
                        name: "FK_Knjige_VrsteGrade",
                        column: x => x.VrsteGradeId,
                        principalTable: "VrsteGrade",
                        principalColumn: "VrstaGradeId");
                });

            migrationBuilder.CreateTable(
                name: "BibliotekaUposleni",
                columns: table => new
                {
                    BibliotekaUposleniId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    BibliotekaId = table.Column<int>(type: "int", nullable: false),
                    DatumUposlenja = table.Column<DateTime>(type: "datetime", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Bibliote__304DBEB3A7395A71", x => x.BibliotekaUposleniId);
                    table.ForeignKey(
                        name: "FKBiblioteka763883",
                        column: x => x.BibliotekaId,
                        principalTable: "Biblioteke",
                        principalColumn: "BibliotekaId");
                    table.ForeignKey(
                        name: "FKBiblioteka995992",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "TipClanarineBiblioteke",
                columns: table => new
                {
                    TipClanarineBibliotekaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                    Trajanje = table.Column<int>(type: "int", nullable: false),
                    Iznos = table.Column<decimal>(type: "decimal(19,2)", nullable: false),
                    BibliotekaId = table.Column<int>(type: "int", nullable: false),
                    ValutaId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__TipClana__4558C5A1507579E8", x => x.TipClanarineBibliotekaId);
                    table.ForeignKey(
                        name: "FKTipClanari390390",
                        column: x => x.BibliotekaId,
                        principalTable: "Biblioteke",
                        principalColumn: "BibliotekaId");
                    table.ForeignKey(
                        name: "FKTipClanari83073",
                        column: x => x.ValutaId,
                        principalTable: "Valute",
                        principalColumn: "ValutaId");
                });

            migrationBuilder.CreateTable(
                name: "BibliotekaCitaociZabrane",
                columns: table => new
                {
                    BibliotekaCitaocZabranaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RokZabrane = table.Column<DateTime>(type: "datetime", nullable: false),
                    BibliotekaId = table.Column<int>(type: "int", nullable: false),
                    CitalacId = table.Column<int>(type: "int", nullable: false),
                    StateMachine = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Bibliote__715D033F62DD5922", x => x.BibliotekaCitaocZabranaId);
                    table.ForeignKey(
                        name: "FKBiblioteka338157",
                        column: x => x.BibliotekaId,
                        principalTable: "Biblioteke",
                        principalColumn: "BibliotekaId");
                    table.ForeignKey(
                        name: "FKBiblioteka377889",
                        column: x => x.CitalacId,
                        principalTable: "Citaoci",
                        principalColumn: "CitalacId");
                });

            migrationBuilder.CreateTable(
                name: "Obavijesti",
                columns: table => new
                {
                    ObavijestId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BibliotekaId = table.Column<int>(type: "int", nullable: true),
                    Naslov = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Tekst = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    Datum = table.Column<DateTime>(type: "datetime", nullable: false),
                    CitalacId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Obavijes__99D330E047910E09", x => x.ObavijestId);
                    table.ForeignKey(
                        name: "FKObavijesti206190",
                        column: x => x.BibliotekaId,
                        principalTable: "Biblioteke",
                        principalColumn: "BibliotekaId");
                    table.ForeignKey(
                        name: "FKObavijesti245922",
                        column: x => x.CitalacId,
                        principalTable: "Citaoci",
                        principalColumn: "CitalacId");
                });

            migrationBuilder.CreateTable(
                name: "Upiti",
                columns: table => new
                {
                    UpitId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Upit = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    Odgovor = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    CitalacId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Upiti__EF8C101287181849", x => x.UpitId);
                    table.ForeignKey(
                        name: "FKUpiti447286",
                        column: x => x.CitalacId,
                        principalTable: "Citaoci",
                        principalColumn: "CitalacId");
                });

            migrationBuilder.CreateTable(
                name: "Uplate",
                columns: table => new
                {
                    UplataId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CitalacId = table.Column<int>(type: "int", nullable: false),
                    BibliotekaId = table.Column<int>(type: "int", nullable: false),
                    Iznos = table.Column<decimal>(type: "decimal(19,2)", nullable: false),
                    DatumUplate = table.Column<DateTime>(type: "datetime", nullable: false),
                    TipUplateId = table.Column<int>(type: "int", nullable: false),
                    ValutaId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uplate__C5B165E60EBF952A", x => x.UplataId);
                    table.ForeignKey(
                        name: "FKUplate728453",
                        column: x => x.TipUplateId,
                        principalTable: "TipoviUplata",
                        principalColumn: "TipUplateId");
                    table.ForeignKey(
                        name: "FKUplate801485",
                        column: x => x.BibliotekaId,
                        principalTable: "Biblioteke",
                        principalColumn: "BibliotekaId");
                    table.ForeignKey(
                        name: "FKUplate841217",
                        column: x => x.CitalacId,
                        principalTable: "Citaoci",
                        principalColumn: "CitalacId");
                    table.ForeignKey(
                        name: "FKUplate862787",
                        column: x => x.ValutaId,
                        principalTable: "Valute",
                        principalColumn: "ValutaId");
                });

            migrationBuilder.CreateTable(
                name: "BibliotekaKnjige",
                columns: table => new
                {
                    BibliotekaKnjigaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BibliotekaId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    BrojKopija = table.Column<int>(type: "int", nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime", nullable: false),
                    Lokacija = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: true),
                    DostupnoCitaonica = table.Column<int>(type: "int", nullable: true),
                    DostupnoPozajmica = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Bibliote__1B347E4186C1376E", x => x.BibliotekaKnjigaId);
                    table.ForeignKey(
                        name: "FKBiblioteka353465",
                        column: x => x.BibliotekaId,
                        principalTable: "Biblioteke",
                        principalColumn: "BibliotekaId");
                    table.ForeignKey(
                        name: "FKBiblioteka650765",
                        column: x => x.KnjigaId,
                        principalTable: "Knjige",
                        principalColumn: "KnjigaId");
                });

            migrationBuilder.CreateTable(
                name: "KnjigaAutori",
                columns: table => new
                {
                    KnjigaAutorId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AutorId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__KnjigaAu__7CCCDDD646DBDFE0", x => x.KnjigaAutorId);
                    table.ForeignKey(
                        name: "FKKnjigaAuto167960",
                        column: x => x.KnjigaId,
                        principalTable: "Knjige",
                        principalColumn: "KnjigaId");
                    table.ForeignKey(
                        name: "FKKnjigaAuto482123",
                        column: x => x.AutorId,
                        principalTable: "Autori",
                        principalColumn: "AutorId");
                });

            migrationBuilder.CreateTable(
                name: "KnjigaCiljneGrupe",
                columns: table => new
                {
                    KnjigaCiljnaGrupaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CiljnaGrupaId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__KnjigaCi__4EFEF21A74FFA6F1", x => x.KnjigaCiljnaGrupaId);
                    table.ForeignKey(
                        name: "FKKnjigaCilj190689",
                        column: x => x.CiljnaGrupaId,
                        principalTable: "CiljneGrupe",
                        principalColumn: "CiljnaGrupaId");
                    table.ForeignKey(
                        name: "FKKnjigaCilj768005",
                        column: x => x.KnjigaId,
                        principalTable: "Knjige",
                        principalColumn: "KnjigaId");
                });

            migrationBuilder.CreateTable(
                name: "KnjigaVrsteSadrzaja",
                columns: table => new
                {
                    KnjigaVrstaSadrzajaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    VrstaSadrzajaId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__KnjigaVr__1CC05BC6BF4EB248", x => x.KnjigaVrstaSadrzajaId);
                    table.ForeignKey(
                        name: "FKKnjigaVrst124097",
                        column: x => x.VrstaSadrzajaId,
                        principalTable: "VrsteSadrzaja",
                        principalColumn: "VrstaSadrzajaId");
                    table.ForeignKey(
                        name: "FKKnjigaVrst688589",
                        column: x => x.KnjigaId,
                        principalTable: "Knjige",
                        principalColumn: "KnjigaId");
                });

            migrationBuilder.CreateTable(
                name: "KorisnikSacuvanaKnjiga",
                columns: table => new
                {
                    KorisnikSacuvanaKnjigaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CitalacId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnik__62EEAC2DF4451BD5", x => x.KorisnikSacuvanaKnjigaId);
                    table.ForeignKey(
                        name: "FKKorisnikSa44095",
                        column: x => x.CitalacId,
                        principalTable: "Citaoci",
                        principalColumn: "CitalacId");
                    table.ForeignKey(
                        name: "FKKorisnikSa920403",
                        column: x => x.KnjigaId,
                        principalTable: "Knjige",
                        principalColumn: "KnjigaId");
                });

            migrationBuilder.CreateTable(
                name: "Clanarine",
                columns: table => new
                {
                    ClanarinaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CitalacId = table.Column<int>(type: "int", nullable: false),
                    BibliotekaId = table.Column<int>(type: "int", nullable: false),
                    UplateId = table.Column<int>(type: "int", nullable: false),
                    TipClanarineBibliotekaId = table.Column<int>(type: "int", nullable: false),
                    Iznos = table.Column<decimal>(type: "decimal(19,2)", nullable: false),
                    Pocetak = table.Column<DateTime>(type: "datetime", nullable: false),
                    Kraj = table.Column<DateTime>(type: "datetime", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Clanarin__C51E3B97E16AE754", x => x.ClanarinaId);
                    table.ForeignKey(
                        name: "FKClanarine35451",
                        column: x => x.BibliotekaId,
                        principalTable: "Biblioteke",
                        principalColumn: "BibliotekaId");
                    table.ForeignKey(
                        name: "FKClanarine4281",
                        column: x => x.CitalacId,
                        principalTable: "Citaoci",
                        principalColumn: "CitalacId");
                    table.ForeignKey(
                        name: "FKClanarine627290",
                        column: x => x.TipClanarineBibliotekaId,
                        principalTable: "TipClanarineBiblioteke",
                        principalColumn: "TipClanarineBibliotekaId");
                    table.ForeignKey(
                        name: "FKClanarine777383",
                        column: x => x.UplateId,
                        principalTable: "Uplate",
                        principalColumn: "UplataId");
                });

            migrationBuilder.CreateTable(
                name: "Pozajmice",
                columns: table => new
                {
                    PozajmicaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CitalacId = table.Column<int>(type: "int", nullable: false),
                    BibliotekaKnjigaId = table.Column<int>(type: "int", nullable: false),
                    DatumPreuzimanja = table.Column<DateTime>(type: "datetime", nullable: false),
                    PreporuceniDatumVracanja = table.Column<DateTime>(type: "datetime", nullable: false),
                    StvarniDatumVracanja = table.Column<DateTime>(type: "datetime", nullable: true),
                    Trajanje = table.Column<int>(type: "int", nullable: false),
                    MoguceProduziti = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Pozajmic__7F2251F1A78DEC0B", x => x.PozajmicaId);
                    table.ForeignKey(
                        name: "FKPozajmice338406",
                        column: x => x.BibliotekaKnjigaId,
                        principalTable: "BibliotekaKnjige",
                        principalColumn: "BibliotekaKnjigaId");
                    table.ForeignKey(
                        name: "FKPozajmice865313",
                        column: x => x.CitalacId,
                        principalTable: "Citaoci",
                        principalColumn: "CitalacId");
                });

            migrationBuilder.CreateTable(
                name: "Rezervacije",
                columns: table => new
                {
                    RezervacijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CitalacId = table.Column<int>(type: "int", nullable: false),
                    BibliotekaKnjigaId = table.Column<int>(type: "int", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: false),
                    Odobreno = table.Column<bool>(type: "bit", nullable: true),
                    RokRezervacije = table.Column<DateTime>(type: "datetime", nullable: true),
                    Ponistena = table.Column<bool>(type: "bit", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Rezervac__CABA44DDF2AB12E6", x => x.RezervacijaId);
                    table.ForeignKey(
                        name: "FKRezervacij386618",
                        column: x => x.CitalacId,
                        principalTable: "Citaoci",
                        principalColumn: "CitalacId");
                    table.ForeignKey(
                        name: "FKRezervacij817101",
                        column: x => x.BibliotekaKnjigaId,
                        principalTable: "BibliotekaKnjige",
                        principalColumn: "BibliotekaKnjigaId");
                });

            migrationBuilder.CreateTable(
                name: "Penali",
                columns: table => new
                {
                    PenalId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PozajmicaId = table.Column<int>(type: "int", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    Iznos = table.Column<decimal>(type: "decimal(19,2)", nullable: false),
                    UplataId = table.Column<int>(type: "int", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Penali__CE46DA9C31EE0FBA", x => x.PenalId);
                    table.ForeignKey(
                        name: "FKPenali189592",
                        column: x => x.UplataId,
                        principalTable: "Uplate",
                        principalColumn: "UplataId");
                    table.ForeignKey(
                        name: "FKPenali769294",
                        column: x => x.PozajmicaId,
                        principalTable: "Pozajmice",
                        principalColumn: "PozajmicaId");
                });

            migrationBuilder.CreateTable(
                name: "ProduženjePozajmica",
                columns: table => new
                {
                    ProduzenjePozajmiceId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Produzenje = table.Column<int>(type: "int", nullable: false),
                    DatumZahtjeva = table.Column<DateTime>(type: "datetime", nullable: false),
                    NoviRok = table.Column<DateTime>(type: "datetime", nullable: false),
                    Odobreno = table.Column<bool>(type: "bit", nullable: true),
                    PozajmicaId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Produžen__9B28C15E79BEC522", x => x.ProduzenjePozajmiceId);
                    table.ForeignKey(
                        name: "FKProduženje639386",
                        column: x => x.PozajmicaId,
                        principalTable: "Pozajmice",
                        principalColumn: "PozajmicaId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_BibliotekaCitaociZabrane_BibliotekaId",
                table: "BibliotekaCitaociZabrane",
                column: "BibliotekaId");

            migrationBuilder.CreateIndex(
                name: "IX_BibliotekaCitaociZabrane_CitalacId",
                table: "BibliotekaCitaociZabrane",
                column: "CitalacId");

            migrationBuilder.CreateIndex(
                name: "IX_BibliotekaKnjige_BibliotekaId",
                table: "BibliotekaKnjige",
                column: "BibliotekaId");

            migrationBuilder.CreateIndex(
                name: "IX_BibliotekaKnjige_KnjigaId",
                table: "BibliotekaKnjige",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_BibliotekaUposleni_BibliotekaId",
                table: "BibliotekaUposleni",
                column: "BibliotekaId");

            migrationBuilder.CreateIndex(
                name: "IX_BibliotekaUposleni_KorisnikId",
                table: "BibliotekaUposleni",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Biblioteke_KantonId",
                table: "Biblioteke",
                column: "KantonId");

            migrationBuilder.CreateIndex(
                name: "IX_Citaoci_KantonId",
                table: "Citaoci",
                column: "KantonId");

            migrationBuilder.CreateIndex(
                name: "IX_Clanarine_BibliotekaId",
                table: "Clanarine",
                column: "BibliotekaId");

            migrationBuilder.CreateIndex(
                name: "IX_Clanarine_CitalacId",
                table: "Clanarine",
                column: "CitalacId");

            migrationBuilder.CreateIndex(
                name: "IX_Clanarine_TipClanarineBibliotekaId",
                table: "Clanarine",
                column: "TipClanarineBibliotekaId");

            migrationBuilder.CreateIndex(
                name: "IX_Clanarine_UplateId",
                table: "Clanarine",
                column: "UplateId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaAutori_AutorId",
                table: "KnjigaAutori",
                column: "AutorId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaAutori_KnjigaId",
                table: "KnjigaAutori",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaCiljneGrupe_CiljnaGrupaId",
                table: "KnjigaCiljneGrupe",
                column: "CiljnaGrupaId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaCiljneGrupe_KnjigaId",
                table: "KnjigaCiljneGrupe",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaVrsteSadrzaja_KnjigaId",
                table: "KnjigaVrsteSadrzaja",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaVrsteSadrzaja_VrstaSadrzajaId",
                table: "KnjigaVrsteSadrzaja",
                column: "VrstaSadrzajaId");

            migrationBuilder.CreateIndex(
                name: "IX_Knjige_IzdavacId",
                table: "Knjige",
                column: "IzdavacId");

            migrationBuilder.CreateIndex(
                name: "IX_Knjige_JezikId",
                table: "Knjige",
                column: "JezikId");

            migrationBuilder.CreateIndex(
                name: "IX_Knjige_UvezId",
                table: "Knjige",
                column: "UvezId");

            migrationBuilder.CreateIndex(
                name: "IX_Knjige_VrsteGradeId",
                table: "Knjige",
                column: "VrsteGradeId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisniciUloge_KorisnikId",
                table: "KorisniciUloge",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisniciUloge_UlogaId",
                table: "KorisniciUloge",
                column: "UlogaId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikSacuvanaKnjiga_CitalacId",
                table: "KorisnikSacuvanaKnjiga",
                column: "CitalacId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikSacuvanaKnjiga_KnjigaId",
                table: "KorisnikSacuvanaKnjiga",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_Obavijesti_BibliotekaId",
                table: "Obavijesti",
                column: "BibliotekaId");

            migrationBuilder.CreateIndex(
                name: "IX_Obavijesti_CitalacId",
                table: "Obavijesti",
                column: "CitalacId");

            migrationBuilder.CreateIndex(
                name: "IX_Penali_PozajmicaId",
                table: "Penali",
                column: "PozajmicaId");

            migrationBuilder.CreateIndex(
                name: "IX_Penali_UplataId",
                table: "Penali",
                column: "UplataId");

            migrationBuilder.CreateIndex(
                name: "IX_Pozajmice_BibliotekaKnjigaId",
                table: "Pozajmice",
                column: "BibliotekaKnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_Pozajmice_CitalacId",
                table: "Pozajmice",
                column: "CitalacId");

            migrationBuilder.CreateIndex(
                name: "IX_ProduženjePozajmica_PozajmicaId",
                table: "ProduženjePozajmica",
                column: "PozajmicaId");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacije_BibliotekaKnjigaId",
                table: "Rezervacije",
                column: "BibliotekaKnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacije_CitalacId",
                table: "Rezervacije",
                column: "CitalacId");

            migrationBuilder.CreateIndex(
                name: "IX_TipClanarineBiblioteke_BibliotekaId",
                table: "TipClanarineBiblioteke",
                column: "BibliotekaId");

            migrationBuilder.CreateIndex(
                name: "IX_TipClanarineBiblioteke_ValutaId",
                table: "TipClanarineBiblioteke",
                column: "ValutaId");

            migrationBuilder.CreateIndex(
                name: "IX_Upiti_CitalacId",
                table: "Upiti",
                column: "CitalacId");

            migrationBuilder.CreateIndex(
                name: "IX_Uplate_BibliotekaId",
                table: "Uplate",
                column: "BibliotekaId");

            migrationBuilder.CreateIndex(
                name: "IX_Uplate_CitalacId",
                table: "Uplate",
                column: "CitalacId");

            migrationBuilder.CreateIndex(
                name: "IX_Uplate_TipUplateId",
                table: "Uplate",
                column: "TipUplateId");

            migrationBuilder.CreateIndex(
                name: "IX_Uplate_ValutaId",
                table: "Uplate",
                column: "ValutaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BibliotekaCitaociZabrane");

            migrationBuilder.DropTable(
                name: "BibliotekaUposleni");

            migrationBuilder.DropTable(
                name: "Clanarine");

            migrationBuilder.DropTable(
                name: "KnjigaAutori");

            migrationBuilder.DropTable(
                name: "KnjigaCiljneGrupe");

            migrationBuilder.DropTable(
                name: "KnjigaVrsteSadrzaja");

            migrationBuilder.DropTable(
                name: "KorisniciUloge");

            migrationBuilder.DropTable(
                name: "KorisnikSacuvanaKnjiga");

            migrationBuilder.DropTable(
                name: "Obavijesti");

            migrationBuilder.DropTable(
                name: "Penali");

            migrationBuilder.DropTable(
                name: "ProduženjePozajmica");

            migrationBuilder.DropTable(
                name: "Rezervacije");

            migrationBuilder.DropTable(
                name: "Upiti");

            migrationBuilder.DropTable(
                name: "TipClanarineBiblioteke");

            migrationBuilder.DropTable(
                name: "Autori");

            migrationBuilder.DropTable(
                name: "CiljneGrupe");

            migrationBuilder.DropTable(
                name: "VrsteSadrzaja");

            migrationBuilder.DropTable(
                name: "Korisnici");

            migrationBuilder.DropTable(
                name: "Uloge");

            migrationBuilder.DropTable(
                name: "Uplate");

            migrationBuilder.DropTable(
                name: "Pozajmice");

            migrationBuilder.DropTable(
                name: "TipoviUplata");

            migrationBuilder.DropTable(
                name: "Valute");

            migrationBuilder.DropTable(
                name: "BibliotekaKnjige");

            migrationBuilder.DropTable(
                name: "Citaoci");

            migrationBuilder.DropTable(
                name: "Biblioteke");

            migrationBuilder.DropTable(
                name: "Knjige");

            migrationBuilder.DropTable(
                name: "Kantoni");

            migrationBuilder.DropTable(
                name: "Jezici");

            migrationBuilder.DropTable(
                name: "Izdavaci");

            migrationBuilder.DropTable(
                name: "Uvezi");

            migrationBuilder.DropTable(
                name: "VrsteGrade");
        }
    }
}
