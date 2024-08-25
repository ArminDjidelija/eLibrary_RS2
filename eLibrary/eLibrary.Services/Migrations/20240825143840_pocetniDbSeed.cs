using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eLibrary.Services.Migrations
{
    /// <inheritdoc />
    public partial class pocetniDbSeed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Uvezi",
                keyColumn: "UvezId",
                keyValue: 5);

            migrationBuilder.UpdateData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 1,
                column: "Prezime",
                value: "Tolstoj");

            migrationBuilder.UpdateData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 4,
                columns: new[] { "Ime", "Prezime" },
                values: new object[] { "Sergej", "Jesenjin" });

            migrationBuilder.InsertData(
                table: "Autori",
                columns: new[] { "AutorId", "GodinaRodjenja", "Ime", "IsDeleted", "Prezime", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 10, 1828, "Jules", false, "Verne", null },
                    { 11, 1910, "Meša", false, "Selimović", null }
                });

            migrationBuilder.InsertData(
                table: "Biblioteke",
                columns: new[] { "BibliotekaId", "Adresa", "IsDeleted", "KantonId", "Mail", "Naziv", "Opis", "Telefon", "VrijemeBrisanja", "Web" },
                values: new object[,]
                {
                    { 2, "Maršala Tita 55", false, 7, "nbm@mail", "Narodna biblioteka Mostar", "Opis biblioteke Narodna Mostar", "06456465", null, "www.npm.ba" },
                    { 3, "Sjeverni logor, bb", false, 7, "mail", "Univerzitetska biblioteka Džemal Bijedić", "Opis biblioteke", "06456465", null, "unmo.ba" },
                    { 4, "Vilsonovo šetalište", false, 9, "unbs@gmail.com", "Univerzitetska biblioteka Sarajevo", "Opis biblioteke", "789789789", null, "www.unbs.ba" }
                });

            migrationBuilder.InsertData(
                table: "Citaoci",
                columns: new[] { "CitalacId", "DatumRegistracije", "Email", "Ime", "Institucija", "IsDeleted", "KantonId", "KorisnickoIme", "LozinkaHash", "LozinkaSalt", "Prezime", "Status", "Telefon", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "citalac1@gmail.com", "Citalac1", "Fakultet informacijskih tehnologija", false, 7, "citalac1", "hkQWX9j6A9fmDteJh3G8uYfLwW0=", "Mze6gFYvmgrOG8urSD+mhg==", "Citalac1", true, "06060606", null },
                    { 2, new DateTime(2024, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "citalac2@gmail.com", "Citalac2", "Fakultet informacijskih tehnologija", false, 7, "citalac2", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Citalac2", true, "06060606", null }
                });

            migrationBuilder.InsertData(
                table: "Izdavaci",
                columns: new[] { "IzdavacId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 10, false, "Fakultet informacijskih tehnologija Mostar", null },
                    { 11, false, "Građevinski fakultet Mostar", null },
                    { 12, false, "Mašinski fakultet Mostar", null }
                });

            migrationBuilder.InsertData(
                table: "Knjige",
                columns: new[] { "KnjigaId", "BrojIzdanja", "BrojStranica", "GodinaIzdanja", "IsDeleted", "Isbn", "IzdavacId", "JezikId", "Napomena", "Naslov", "Slika", "UvezId", "VrijemeBrisanja", "VrsteGradeId" },
                values: new object[,]
                {
                    { 1, 1, 89, 2020, false, "978-9958-771-38-5", 1, 1, "", "Starac i more", null, 1, null, 1 },
                    { 2, 1, 890, 2020, false, "978-86-521-3555-4", 1, 1, "", "Ana Karenjina", null, 1, null, 1 },
                    { 4, 1, 800, 2020, false, "978-86-521-4508-9", 1, 1, "", "Rat i mir 1", null, 1, null, 1 },
                    { 5, 1, 220, 2020, false, "978-86-447-0687-8", 1, 1, "", "Proces", null, 1, null, 1 },
                    { 6, 1, 123, 2020, false, "9788663693722", 1, 1, "", "Kapetanova kći", null, 1, null, 1 },
                    { 7, 1, 230, 2020, false, "978-9958-771-38-5", 1, 1, "", "105 pjesama", null, 1, null, 1 },
                    { 8, 1, 267, 2020, false, "978-86-7674-205-9", 1, 1, "", "1984", null, 1, null, 1 },
                    { 9, 1, 430, 2020, false, "978-953-0-60381-3", 1, 1, "", "Pustolovine Toma Sawyera", null, 1, null, 1 },
                    { 10, 1, 56, 2020, false, "978-9958-41-300-1", 1, 1, "", "Put oko svijeta za 80 dana", null, 1, null, 1 },
                    { 13, 1, 832, 2020, false, "978-86-521-4509-6", 1, 1, "", "Rat i mir II", null, 1, null, 1 },
                    { 14, 1, 616, 2020, false, "978-9958-18-142-9", 1, 1, "", "Zločin i kazna", null, 1, null, 1 },
                    { 15, 1, 418, 2020, false, "978-9958-29-222-4", 1, 1, "", "Derviš i smrt", null, 1, null, 1 },
                    { 20, 1, 160, 2020, false, "953-196-904-3", 1, 1, "", "Dekameron", null, 1, null, 1 }
                });

            migrationBuilder.InsertData(
                table: "Korisnici",
                columns: new[] { "KorisnikId", "Email", "Ime", "IsDeleted", "KorisnickoIme", "LozinkaHash", "LozinkaSalt", "Prezime", "Status", "Telefon", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, "admin@elibrary.ba", "Admin", false, "admin", "c1WzmHn/IfIrmkynZcsLyWHuzqE=", "dgCBLLURssjdW6U+61MC+Q==", "Admin", true, "06060606060606", null },
                    { 2, "bibl1@gmail.com", "Bibliotekar1", false, "bibliotekar1", "9MF7KTZlFft51eQvyTtlgmYQlOs=", "dgCBLLURssjdW6U+61MC+Q==", "Bibliotekar1", true, "06060606", null },
                    { 3, "bibl2@gmail.com", "Bibliotekar2", false, "bibliotekar2", "aK8cml17lpwbriKaVDWacJdixas=", "dgCBLLURssjdW6U+61MC+Q==", "Bibliotekar2", true, "06060606", null }
                });

            migrationBuilder.InsertData(
                table: "TipClanarineBiblioteke",
                columns: new[] { "TipClanarineBibliotekaId", "BibliotekaId", "IsDeleted", "Iznos", "Naziv", "Trajanje", "ValutaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 2, false, 4.00m, "Mjesečna", 30, 1, null },
                    { 2, 2, false, 10.00m, "Tromjesečna", 90, 1, null },
                    { 3, 2, false, 15.00m, "Polugodišnja", 180, 1, null },
                    { 4, 2, false, 20.00m, "Godišnja", 365, 1, null }
                });

            migrationBuilder.InsertData(
                table: "Uvezi",
                columns: new[] { "UvezId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[] { 3, false, "Bez uveza", null });

            migrationBuilder.InsertData(
                table: "BibliotekaKnjige",
                columns: new[] { "BibliotekaKnjigaId", "BibliotekaId", "BrojKopija", "DatumDodavanja", "DostupnoCitaonica", "DostupnoPozajmica", "IsDeleted", "KnjigaId", "Lokacija", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 12, 2, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(514), 25, 20, false, 1, "B1", null },
                    { 13, 2, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(519), 25, 20, false, 2, "B1", null },
                    { 15, 2, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(523), 25, 20, false, 4, "B1", null },
                    { 16, 2, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(526), 25, 20, false, 7, "B1", null },
                    { 17, 2, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(529), 25, 20, false, 6, "B1", null },
                    { 18, 3, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(533), 25, 20, false, 6, "B1", null },
                    { 19, 3, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(536), 25, 20, false, 4, "B1", null },
                    { 20, 3, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(540), 25, 20, false, 8, "B1", null },
                    { 21, 3, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(543), 25, 20, false, 1, "B1", null },
                    { 22, 3, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(547), 25, 20, false, 10, "B1", null },
                    { 26, 4, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(550), 25, 20, false, 1, "B1", null },
                    { 27, 4, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(553), 25, 20, false, 2, "B1", null },
                    { 28, 4, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(557), 25, 20, false, 5, "B1", null },
                    { 29, 4, 30, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(560), 25, 20, false, 6, "B1", null }
                });

            migrationBuilder.InsertData(
                table: "BibliotekaUposleni",
                columns: new[] { "BibliotekaUposleniId", "BibliotekaId", "DatumUposlenja", "IsDeleted", "KorisnikId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 2, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(195), false, 2, null },
                    { 2, 3, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(270), false, 3, null }
                });

            migrationBuilder.InsertData(
                table: "CitalacKnjigaLogs",
                columns: new[] { "CitalacKnjigaLogId", "CitalacId", "KnjigaId" },
                values: new object[,]
                {
                    { 1, 1, 1 },
                    { 2, 1, 2 },
                    { 3, 2, 5 },
                    { 4, 2, 6 }
                });

            migrationBuilder.InsertData(
                table: "KnjigaAutori",
                columns: new[] { "KnjigaAutorId", "AutorId", "IsDeleted", "KnjigaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 2, false, 1, null },
                    { 2, 1, false, 2, null },
                    { 3, 1, false, 4, null },
                    { 4, 3, false, 5, null },
                    { 5, 5, false, 6, null },
                    { 6, 4, false, 7, null },
                    { 7, 7, false, 8, null },
                    { 8, 8, false, 9, null },
                    { 9, 10, false, 10, null },
                    { 10, 1, false, 13, null },
                    { 11, 6, false, 14, null },
                    { 12, 11, false, 15, null },
                    { 17, 10, false, 20, null }
                });

            migrationBuilder.InsertData(
                table: "KnjigaCiljneGrupe",
                columns: new[] { "KnjigaCiljnaGrupaId", "CiljnaGrupaId", "IsDeleted", "KnjigaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 1, false, 1, null },
                    { 2, 2, false, 1, null },
                    { 3, 1, false, 2, null },
                    { 4, 5, false, 2, null },
                    { 5, 3, false, 2, null },
                    { 6, 6, false, 4, null },
                    { 7, 1, false, 5, null },
                    { 8, 4, false, 5, null },
                    { 9, 5, false, 5, null },
                    { 10, 1, false, 6, null },
                    { 11, 4, false, 6, null },
                    { 12, 5, false, 6, null },
                    { 13, 1, false, 7, null },
                    { 14, 3, false, 7, null },
                    { 15, 1, false, 8, null },
                    { 16, 3, false, 8, null },
                    { 17, 2, false, 9, null },
                    { 18, 6, false, 9, null },
                    { 19, 6, false, 10, null },
                    { 20, 2, false, 10, null },
                    { 21, 1, false, 13, null },
                    { 22, 3, false, 13, null },
                    { 23, 5, false, 13, null },
                    { 24, 5, false, 14, null },
                    { 25, 1, false, 14, null },
                    { 26, 3, false, 14, null },
                    { 27, 5, false, 15, null },
                    { 28, 6, false, 20, null }
                });

            migrationBuilder.InsertData(
                table: "KnjigaVrsteSadrzaja",
                columns: new[] { "KnjigaVrstaSadrzajaId", "IsDeleted", "KnjigaId", "VrijemeBrisanja", "VrstaSadrzajaId" },
                values: new object[,]
                {
                    { 1, false, 1, null, 1 },
                    { 2, false, 2, null, 1 },
                    { 3, false, 2, null, 24 },
                    { 4, false, 4, null, 1 },
                    { 5, false, 4, null, 24 },
                    { 6, false, 5, null, 1 },
                    { 7, false, 5, null, 24 },
                    { 8, false, 6, null, 1 },
                    { 9, false, 6, null, 24 },
                    { 10, false, 7, null, 2 },
                    { 11, false, 7, null, 24 },
                    { 12, false, 8, null, 1 },
                    { 13, false, 8, null, 24 },
                    { 14, false, 9, null, 25 },
                    { 15, false, 9, null, 26 },
                    { 16, false, 10, null, 1 },
                    { 17, false, 10, null, 26 },
                    { 18, false, 13, null, 1 },
                    { 19, false, 13, null, 24 },
                    { 20, false, 14, null, 1 },
                    { 21, false, 14, null, 24 },
                    { 22, false, 15, null, 1 },
                    { 29, false, 20, null, 1 },
                    { 30, false, 20, null, 24 }
                });

            migrationBuilder.InsertData(
                table: "KorisniciUloge",
                columns: new[] { "KorisnikUlogaId", "IsDeleted", "KorisnikId", "UlogaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, 1, 2, null },
                    { 2, false, 2, 1, null },
                    { 3, false, 3, 1, null }
                });

            migrationBuilder.InsertData(
                table: "KorisnikSacuvanaKnjiga",
                columns: new[] { "KorisnikSacuvanaKnjigaId", "CitalacId", "IsDeleted", "KnjigaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 1, false, 1, null },
                    { 2, 1, false, 4, null },
                    { 3, 1, false, 5, null },
                    { 4, 2, false, 1, null },
                    { 5, 2, false, 5, null },
                    { 6, 2, false, 6, null }
                });

            migrationBuilder.InsertData(
                table: "Obavijesti",
                columns: new[] { "ObavijestId", "BibliotekaId", "CitalacId", "Datum", "IsDeleted", "Naslov", "Tekst", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 2, 2, null, new DateTime(2024, 8, 4, 17, 6, 34, 513, DateTimeKind.Unspecified), false, "Novi naslovi", "U našu biblioteku 5.8.2024. stižu novi bestselleri koje ćete moži preuzeti svakog dana u našoj biblioteci.", null },
                    { 3, 2, null, new DateTime(2024, 8, 4, 17, 8, 3, 270, DateTimeKind.Unspecified), false, "Novi naslovi", "U našu biblioteku 5.8.2024. stižu novi bestselleri koje ćete moži preuzeti svakog dana u našoj biblioteci.", null },
                    { 4, 2, 1, new DateTime(2024, 8, 4, 17, 47, 26, 453, DateTimeKind.Unspecified), false, "Vracanje pozajmice", "Prešli ste rok pozajmice, potrebno je istu vratiti u što ranijem roku", null }
                });

            migrationBuilder.InsertData(
                table: "TipClanarineBiblioteke",
                columns: new[] { "TipClanarineBibliotekaId", "BibliotekaId", "IsDeleted", "Iznos", "Naziv", "Trajanje", "ValutaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 5, 3, false, 5.00m, "Mjesečna", 30, 1, null },
                    { 6, 3, false, 30.00m, "Godišnja", 365, 1, null },
                    { 7, 4, false, 35.00m, "Godišnja", 365, 1, null }
                });

            migrationBuilder.InsertData(
                table: "Upiti",
                columns: new[] { "UpitId", "CitalacId", "IsDeleted", "Naslov", "Odgovor", "Upit", "VrijemeBrisanja" },
                values: new object[] { 1, 1, false, "Greška u aplikaciji", "Problem će uskoro biti riješen.", "Nakon klika potrebno je nešto napraviti...", null });

            migrationBuilder.InsertData(
                table: "Uplate",
                columns: new[] { "UplataId", "BibliotekaId", "CitalacId", "DatumUplate", "IsDeleted", "Iznos", "TipUplateId", "ValutaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 2, 1, new DateTime(2024, 8, 10, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(756), false, 4.00m, 1, 1, null },
                    { 2, 2, 1, new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(761), false, 10.00m, 1, 1, null },
                    { 3, 2, 2, new DateTime(2024, 8, 10, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(764), false, 4.00m, 2, 1, null },
                    { 4, 2, 2, new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(768), false, 10.00m, 1, 1, null },
                    { 5, 2, 1, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(771), false, 10.00m, 1, 1, null },
                    { 6, 2, 2, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(774), false, 10.00m, 1, 1, null }
                });

            migrationBuilder.InsertData(
                table: "Clanarine",
                columns: new[] { "ClanarinaId", "BibliotekaId", "CitalacId", "IsDeleted", "Iznos", "Kraj", "Pocetak", "TipClanarineBibliotekaId", "UplateId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 2, 1, false, 4.00m, new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(969), new DateTime(2024, 8, 10, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(966), 1, 1, null },
                    { 2, 2, 1, false, 10.00m, new DateTime(2024, 12, 8, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(975), new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(973), 2, 2, null },
                    { 3, 2, 2, false, 4.00m, new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(980), new DateTime(2024, 8, 10, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(978), 1, 3, null },
                    { 4, 2, 2, false, 4.00m, new DateTime(2024, 12, 8, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(985), new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(983), 1, 4, null }
                });

            migrationBuilder.InsertData(
                table: "Pozajmice",
                columns: new[] { "PozajmicaId", "BibliotekaKnjigaId", "CitalacId", "DatumPreuzimanja", "IsDeleted", "MoguceProduziti", "PreporuceniDatumVracanja", "StvarniDatumVracanja", "Trajanje", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 7, 12, 1, new DateTime(2024, 6, 26, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(596), false, true, new DateTime(2024, 7, 3, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(601), new DateTime(2024, 7, 2, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(603), 7, null },
                    { 8, 15, 1, new DateTime(2024, 7, 6, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(607), false, true, new DateTime(2024, 7, 13, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(608), new DateTime(2024, 7, 2, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(610), 7, null },
                    { 9, 16, 1, new DateTime(2024, 7, 16, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(614), false, true, new DateTime(2024, 7, 13, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(615), new DateTime(2024, 7, 12, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(617), 7, null },
                    { 10, 12, 2, new DateTime(2024, 6, 26, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(621), false, true, new DateTime(2024, 7, 3, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(622), new DateTime(2024, 7, 2, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(624), 7, null },
                    { 11, 13, 2, new DateTime(2024, 7, 6, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(628), false, true, new DateTime(2024, 7, 13, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(629), new DateTime(2024, 7, 12, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(631), 7, null },
                    { 12, 12, 2, new DateTime(2024, 7, 16, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(635), false, true, new DateTime(2024, 7, 23, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(636), new DateTime(2024, 7, 22, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(638), 7, null },
                    { 13, 12, 1, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(642), false, true, new DateTime(2024, 9, 1, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(643), null, 7, null },
                    { 14, 12, 2, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(647), false, true, new DateTime(2024, 9, 1, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(648), null, 7, null }
                });

            migrationBuilder.InsertData(
                table: "Rezervacije",
                columns: new[] { "RezervacijaId", "BibliotekaKnjigaId", "CitalacId", "DatumKreiranja", "IsDeleted", "Odobreno", "Ponistena", "RokRezervacije", "State", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 12, 1, new DateTime(2024, 8, 11, 15, 29, 7, 850, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(677), "Ponistena", null },
                    { 2, 12, 1, new DateTime(2024, 8, 11, 15, 29, 7, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(681), "Zavrsena", null },
                    { 3, 12, 2, new DateTime(2024, 8, 11, 15, 29, 7, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(689), "Ponistena", null },
                    { 4, 12, 2, new DateTime(2024, 8, 11, 15, 29, 7, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(692), "Zavrsena", null },
                    { 5, 12, 1, new DateTime(2024, 8, 11, 15, 29, 7, DateTimeKind.Unspecified), false, null, null, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(695), "Kreirana", null },
                    { 6, 12, 2, new DateTime(2024, 8, 11, 15, 29, 7, DateTimeKind.Unspecified), false, null, null, new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(698), "Kreirana", null },
                    { 16, 12, 2, new DateTime(2024, 8, 11, 15, 29, 7, 850, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 19, 10, 5, 30, 787, DateTimeKind.Unspecified), "Ponistena", null },
                    { 17, 12, 2, new DateTime(2024, 8, 11, 15, 34, 46, 240, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 19, 10, 5, 29, 140, DateTimeKind.Unspecified), "Ponistena", null },
                    { 18, 12, 1, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 19, 10, 5, 27, 263, DateTimeKind.Unspecified), "Ponistena", null },
                    { 19, 12, 1, new DateTime(2024, 8, 11, 16, 20, 21, 720, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 18, 13, 11, 24, 200, DateTimeKind.Unspecified), "Zavrsena", null },
                    { 20, 12, 1, new DateTime(2024, 8, 11, 16, 28, 4, 540, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 17, 20, 47, 49, 410, DateTimeKind.Unspecified), "Zavrsena", null },
                    { 21, 12, 1, new DateTime(2024, 8, 11, 17, 38, 31, 480, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 12, 21, 43, 9, 177, DateTimeKind.Unspecified), "Zavrsena", null },
                    { 22, 13, 1, new DateTime(2024, 8, 11, 17, 39, 31, 480, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 12, 18, 38, 3, 653, DateTimeKind.Unspecified), "Zavrsena", null },
                    { 23, 15, 1, new DateTime(2024, 8, 18, 20, 24, 40, 827, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 19, 23, 9, 18, 867, DateTimeKind.Unspecified), "Ponistena", null },
                    { 24, 15, 1, new DateTime(2024, 8, 18, 20, 24, 42, 783, DateTimeKind.Unspecified), false, true, true, new DateTime(2024, 8, 19, 23, 9, 57, 580, DateTimeKind.Unspecified), "Zavrsena", null },
                    { 25, 12, 1, new DateTime(2024, 8, 19, 18, 4, 28, 773, DateTimeKind.Unspecified), false, null, false, null, "Kreirana", null },
                    { 26, 22, 1, new DateTime(2024, 8, 20, 19, 9, 7, 493, DateTimeKind.Unspecified), false, null, true, null, "Ponistena", null }
                });

            migrationBuilder.InsertData(
                table: "Penali",
                columns: new[] { "PenalId", "IsDeleted", "Iznos", "Opis", "PozajmicaId", "UplataId", "ValutaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, 10.00m, "Korisnik vratio knjigu sa pocijepanim stranicama", 7, 5, 1, null },
                    { 2, false, 10.00m, "Korisnik vratio knjigu sa pocijepanim stranicama", 8, 6, 1, null },
                    { 3, false, 10.00m, "Korisnik vratio knjigu sa pocijepanim stranicama", 9, null, 1, null }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 27);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 28);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 29);

            migrationBuilder.DeleteData(
                table: "BibliotekaUposleni",
                keyColumn: "BibliotekaUposleniId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "BibliotekaUposleni",
                keyColumn: "BibliotekaUposleniId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "CitalacKnjigaLogs",
                keyColumn: "CitalacKnjigaLogId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "CitalacKnjigaLogs",
                keyColumn: "CitalacKnjigaLogId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "CitalacKnjigaLogs",
                keyColumn: "CitalacKnjigaLogId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "CitalacKnjigaLogs",
                keyColumn: "CitalacKnjigaLogId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "KnjigaAutori",
                keyColumn: "KnjigaAutorId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 27);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljneGrupe",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 28);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 29);

            migrationBuilder.DeleteData(
                table: "KnjigaVrsteSadrzaja",
                keyColumn: "KnjigaVrstaSadrzajaId",
                keyValue: 30);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KorisnikSacuvanaKnjiga",
                keyColumn: "KorisnikSacuvanaKnjigaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KorisnikSacuvanaKnjiga",
                keyColumn: "KorisnikSacuvanaKnjigaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KorisnikSacuvanaKnjiga",
                keyColumn: "KorisnikSacuvanaKnjigaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KorisnikSacuvanaKnjiga",
                keyColumn: "KorisnikSacuvanaKnjigaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "KorisnikSacuvanaKnjiga",
                keyColumn: "KorisnikSacuvanaKnjigaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "KorisnikSacuvanaKnjiga",
                keyColumn: "KorisnikSacuvanaKnjigaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Obavijesti",
                keyColumn: "ObavijestId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Obavijesti",
                keyColumn: "ObavijestId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Obavijesti",
                keyColumn: "ObavijestId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Penali",
                keyColumn: "PenalId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Penali",
                keyColumn: "PenalId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Penali",
                keyColumn: "PenalId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Upiti",
                keyColumn: "UpitId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Uvezi",
                keyColumn: "UvezId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "Biblioteke",
                keyColumn: "BibliotekaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Biblioteke",
                keyColumn: "BibliotekaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Citaoci",
                keyColumn: "CitalacId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Citaoci",
                keyColumn: "CitalacId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Biblioteke",
                keyColumn: "BibliotekaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Knjige",
                keyColumn: "KnjigaId",
                keyValue: 7);

            migrationBuilder.UpdateData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 1,
                column: "Prezime",
                value: "Tolstoy");

            migrationBuilder.UpdateData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 4,
                columns: new[] { "Ime", "Prezime" },
                values: new object[] { "Sergey", "Yesenin" });

            migrationBuilder.InsertData(
                table: "Uloge",
                columns: new[] { "UlogaId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[] { 3, false, "Menadzer", null });

            migrationBuilder.InsertData(
                table: "Uvezi",
                columns: new[] { "UvezId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[] { 5, false, "Bez uveza", null });
        }
    }
}
