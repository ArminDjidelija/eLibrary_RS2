using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eLibrary.Services.Migrations
{
    /// <inheritdoc />
    public partial class uklonjena_biblioteka_citaoci_zabrane : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Autori",
                columns: new[] { "AutorId", "GodinaRodjenja", "Ime", "IsDeleted", "Prezime", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 1828, "Leo", false, "Tolstoy", null },
                    { 2, 1899, "Ernest", false, "Hemingway", null },
                    { 3, 1883, "Franz", false, "Kafka", null },
                    { 4, 1895, "Sergey", false, "Yesenin", null },
                    { 5, 1799, "Alexander", false, "Pushkin", null },
                    { 6, 1821, "Fjodor", false, "Dostojevski", null },
                    { 7, 1903, "George", false, "Orwell", null },
                    { 8, 1835, "Mark", false, "Twain", null },
                    { 9, 1845, "Charles", false, "Dickens", null }
                });

            migrationBuilder.InsertData(
                table: "CiljneGrupe",
                columns: new[] { "CiljnaGrupaId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Odrasli >18", null },
                    { 2, false, "Djeca", null },
                    { 3, false, "Ozbiljna", null },
                    { 4, false, "10-14", null },
                    { 5, false, "14-18", null },
                    { 6, false, "Opšte štivo", null }
                });

            migrationBuilder.InsertData(
                table: "Izdavaci",
                columns: new[] { "IzdavacId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "BH Most", null },
                    { 2, false, "Globus Media", null },
                    { 3, false, "Laguna", null },
                    { 4, false, "Plato", null },
                    { 5, false, "Nova knjiga, Kosmos", null },
                    { 6, false, "Rabic", null },
                    { 7, false, "Otvorena knjiga", null },
                    { 9, false, "Školska knjiga", null }
                });

            migrationBuilder.InsertData(
                table: "Jezici",
                columns: new[] { "JezikId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Bosanski", null },
                    { 2, false, "Hrvatski", null },
                    { 3, false, "Srpski", null },
                    { 4, false, "Engleski", null },
                    { 5, false, "Crnogorski", null },
                    { 6, false, "Njemački", null },
                    { 7, false, "Španski", null },
                    { 8, false, "Francuski", null },
                    { 9, false, "Ruski", null },
                    { 10, false, "Slovenski", null },
                    { 11, false, "Indijski", null }
                });

            migrationBuilder.InsertData(
                table: "Kantoni",
                columns: new[] { "KantonId", "IsDeleted", "Naziv", "Skracenica", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Unsko-sanski kanton", "USK", null },
                    { 2, false, "Posavski kanton", "PK", null },
                    { 3, false, "Tuzlanski kanton", "TK", null },
                    { 4, false, "Zenicko-dobojski kanton", "ZDK", null },
                    { 5, false, "Bosansko-podrinjski kanton Goražde", "BPK", null },
                    { 6, false, "Srednjobosanski kanton", "SBK", null },
                    { 7, false, "Hercegovacko-neretvanski kanton", "HNK", null },
                    { 8, false, "Zapadnohercegovacki kanton", "ZHK", null },
                    { 9, false, "Kanton Sarajevo", "KS", null },
                    { 10, false, "Kanton 10", "K10", null }
                });

            migrationBuilder.InsertData(
                table: "TipoviUplata",
                columns: new[] { "TipUplateId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Online", null },
                    { 2, false, "Keš", null }
                });

            migrationBuilder.InsertData(
                table: "Uloge",
                columns: new[] { "UlogaId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Bibliotekar", null },
                    { 2, false, "Administrator", null },
                    { 3, false, "Menadzer", null }
                });

            migrationBuilder.InsertData(
                table: "Uvezi",
                columns: new[] { "UvezId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Mehki", null },
                    { 2, false, "Tvrdi", null },
                    { 5, false, "Bez uveza", null }
                });

            migrationBuilder.InsertData(
                table: "Valute",
                columns: new[] { "ValutaId", "IsDeleted", "Naziv", "Skracenica", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Konvertibilna marka", "KM", null },
                    { 2, false, "Euro", "EUR", null }
                });

            migrationBuilder.InsertData(
                table: "VrsteGrade",
                columns: new[] { "VrstaGradeId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Knjiga", null },
                    { 3, false, "Časopis", null },
                    { 4, false, "E-Knjiga", null },
                    { 5, false, "Audio knjiga", null },
                    { 6, false, "Članak", null }
                });

            migrationBuilder.InsertData(
                table: "VrsteSadrzaja",
                columns: new[] { "VrstaSadrzajaId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Roman", null },
                    { 2, false, "Poezija", null },
                    { 3, false, "Fantastika", null },
                    { 4, false, "Putopis", null },
                    { 5, false, "Kriminalistika", null },
                    { 6, false, "Ljubavni roman", null },
                    { 7, false, "Triler", null },
                    { 8, false, "Vestern", null },
                    { 9, false, "Modernizam", null },
                    { 10, false, "Pustolovni roman", null },
                    { 11, false, "Naucna fantastika", null },
                    { 12, false, "Doktorski rad", null },
                    { 13, false, "Diplomski rad", null },
                    { 14, false, "Magistarski rad", null },
                    { 15, false, "Stručni rad", null },
                    { 16, false, "Udžbenik", null },
                    { 17, false, "Tehnički izvještaj", null },
                    { 18, false, "Zbornik", null },
                    { 19, false, "Rječnik", null },
                    { 21, false, "Istraživački rad", null },
                    { 22, false, "Enciklopedija", null },
                    { 23, false, "Biografija", null },
                    { 24, false, "Književnost", null },
                    { 25, false, "Bajka", null },
                    { 26, false, "Dječije knjige", null }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Autori",
                keyColumn: "AutorId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "CiljneGrupe",
                keyColumn: "CiljnaGrupaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "CiljneGrupe",
                keyColumn: "CiljnaGrupaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "CiljneGrupe",
                keyColumn: "CiljnaGrupaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "CiljneGrupe",
                keyColumn: "CiljnaGrupaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "CiljneGrupe",
                keyColumn: "CiljnaGrupaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "CiljneGrupe",
                keyColumn: "CiljnaGrupaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Izdavaci",
                keyColumn: "IzdavacId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Jezici",
                keyColumn: "JezikId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Kantoni",
                keyColumn: "KantonId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "TipoviUplata",
                keyColumn: "TipUplateId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "TipoviUplata",
                keyColumn: "TipUplateId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Uvezi",
                keyColumn: "UvezId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Uvezi",
                keyColumn: "UvezId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Uvezi",
                keyColumn: "UvezId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Valute",
                keyColumn: "ValutaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Valute",
                keyColumn: "ValutaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "VrsteGrade",
                keyColumn: "VrstaGradeId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "VrsteGrade",
                keyColumn: "VrstaGradeId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "VrsteGrade",
                keyColumn: "VrstaGradeId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "VrsteGrade",
                keyColumn: "VrstaGradeId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "VrsteGrade",
                keyColumn: "VrstaGradeId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "VrsteSadrzaja",
                keyColumn: "VrstaSadrzajaId",
                keyValue: 26);
        }
    }
}
