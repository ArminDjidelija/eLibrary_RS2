using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eLibrary.Services.Migrations
{
    /// <inheritdoc />
    public partial class updateSeedBaze : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 12,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3430));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 13,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3449));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 15,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3453));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 16,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3458));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 17,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3462));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 18,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3466));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 19,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3471));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 20,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3475));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 21,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3480));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 22,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3484));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 26,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3487));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 27,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3491));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 28,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3498));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 29,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3502));

            migrationBuilder.UpdateData(
                table: "BibliotekaUposleni",
                keyColumn: "BibliotekaUposleniId",
                keyValue: 1,
                column: "DatumUposlenja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3010));

            migrationBuilder.UpdateData(
                table: "BibliotekaUposleni",
                keyColumn: "BibliotekaUposleniId",
                keyValue: 2,
                column: "DatumUposlenja",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3072));

            migrationBuilder.UpdateData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 1,
                columns: new[] { "Kraj", "Pocetak" },
                values: new object[] { new DateTime(2024, 9, 9, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3936), new DateTime(2024, 8, 10, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3932) });

            migrationBuilder.UpdateData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 2,
                columns: new[] { "Kraj", "Pocetak" },
                values: new object[] { new DateTime(2024, 12, 8, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3948), new DateTime(2024, 9, 9, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3946) });

            migrationBuilder.UpdateData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 3,
                columns: new[] { "Kraj", "Pocetak" },
                values: new object[] { new DateTime(2024, 9, 9, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3954), new DateTime(2024, 8, 10, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3952) });

            migrationBuilder.UpdateData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 4,
                columns: new[] { "Kraj", "Pocetak" },
                values: new object[] { new DateTime(2024, 12, 8, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3959), new DateTime(2024, 9, 9, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3957) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 7,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 6, 26, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3553), new DateTime(2024, 7, 3, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3558), new DateTime(2024, 7, 2, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3560) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 8,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 7, 6, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3564), new DateTime(2024, 7, 13, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3566), new DateTime(2024, 7, 2, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3568) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 9,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 7, 16, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3572), new DateTime(2024, 7, 13, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3574), new DateTime(2024, 7, 12, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3576) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 10,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 6, 26, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3581), new DateTime(2024, 7, 3, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3583), new DateTime(2024, 7, 2, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3585) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 11,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 7, 6, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3588), new DateTime(2024, 7, 13, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3590), new DateTime(2024, 7, 12, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3592) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 12,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 7, 16, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3596), new DateTime(2024, 7, 23, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3598), new DateTime(2024, 7, 22, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3600) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 13,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja" },
                values: new object[] { new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3603), new DateTime(2024, 9, 1, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3605) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 14,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja" },
                values: new object[] { new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3609), new DateTime(2024, 9, 1, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3610) });

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 1,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3638));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 2,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3643));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 3,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3647));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 4,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3662));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 5,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3665));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 6,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3668));

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 1,
                column: "BibliotekaId",
                value: 2);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 2,
                column: "BibliotekaId",
                value: 2);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 3,
                column: "BibliotekaId",
                value: 2);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 4,
                column: "BibliotekaId",
                value: 2);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 5,
                column: "BibliotekaId",
                value: 3);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 6,
                column: "BibliotekaId",
                value: 3);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 7,
                column: "BibliotekaId",
                value: 3);

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 1,
                column: "DatumUplate",
                value: new DateTime(2024, 8, 10, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3723));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 2,
                column: "DatumUplate",
                value: new DateTime(2024, 9, 9, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3729));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 3,
                column: "DatumUplate",
                value: new DateTime(2024, 8, 10, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3732));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 4,
                column: "DatumUplate",
                value: new DateTime(2024, 9, 9, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3736));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 5,
                column: "DatumUplate",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3740));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 6,
                column: "DatumUplate",
                value: new DateTime(2024, 8, 25, 17, 37, 21, 384, DateTimeKind.Local).AddTicks(3743));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 12,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(514));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 13,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(519));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 15,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(523));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 16,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(526));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 17,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(529));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 18,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(533));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 19,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(536));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 20,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(540));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 21,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(543));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 22,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(547));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 26,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(550));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 27,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(553));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 28,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(557));

            migrationBuilder.UpdateData(
                table: "BibliotekaKnjige",
                keyColumn: "BibliotekaKnjigaId",
                keyValue: 29,
                column: "DatumDodavanja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(560));

            migrationBuilder.UpdateData(
                table: "BibliotekaUposleni",
                keyColumn: "BibliotekaUposleniId",
                keyValue: 1,
                column: "DatumUposlenja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(195));

            migrationBuilder.UpdateData(
                table: "BibliotekaUposleni",
                keyColumn: "BibliotekaUposleniId",
                keyValue: 2,
                column: "DatumUposlenja",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(270));

            migrationBuilder.UpdateData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 1,
                columns: new[] { "Kraj", "Pocetak" },
                values: new object[] { new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(969), new DateTime(2024, 8, 10, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(966) });

            migrationBuilder.UpdateData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 2,
                columns: new[] { "Kraj", "Pocetak" },
                values: new object[] { new DateTime(2024, 12, 8, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(975), new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(973) });

            migrationBuilder.UpdateData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 3,
                columns: new[] { "Kraj", "Pocetak" },
                values: new object[] { new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(980), new DateTime(2024, 8, 10, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(978) });

            migrationBuilder.UpdateData(
                table: "Clanarine",
                keyColumn: "ClanarinaId",
                keyValue: 4,
                columns: new[] { "Kraj", "Pocetak" },
                values: new object[] { new DateTime(2024, 12, 8, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(985), new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(983) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 7,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 6, 26, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(596), new DateTime(2024, 7, 3, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(601), new DateTime(2024, 7, 2, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(603) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 8,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 7, 6, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(607), new DateTime(2024, 7, 13, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(608), new DateTime(2024, 7, 2, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(610) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 9,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 7, 16, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(614), new DateTime(2024, 7, 13, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(615), new DateTime(2024, 7, 12, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(617) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 10,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 6, 26, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(621), new DateTime(2024, 7, 3, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(622), new DateTime(2024, 7, 2, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(624) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 11,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 7, 6, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(628), new DateTime(2024, 7, 13, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(629), new DateTime(2024, 7, 12, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(631) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 12,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja", "StvarniDatumVracanja" },
                values: new object[] { new DateTime(2024, 7, 16, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(635), new DateTime(2024, 7, 23, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(636), new DateTime(2024, 7, 22, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(638) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 13,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja" },
                values: new object[] { new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(642), new DateTime(2024, 9, 1, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(643) });

            migrationBuilder.UpdateData(
                table: "Pozajmice",
                keyColumn: "PozajmicaId",
                keyValue: 14,
                columns: new[] { "DatumPreuzimanja", "PreporuceniDatumVracanja" },
                values: new object[] { new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(647), new DateTime(2024, 9, 1, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(648) });

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 1,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(677));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 2,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(681));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 3,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(689));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 4,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(692));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 5,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(695));

            migrationBuilder.UpdateData(
                table: "Rezervacije",
                keyColumn: "RezervacijaId",
                keyValue: 6,
                column: "RokRezervacije",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(698));

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 1,
                column: "BibliotekaId",
                value: 2);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 2,
                column: "BibliotekaId",
                value: 2);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 3,
                column: "BibliotekaId",
                value: 2);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 4,
                column: "BibliotekaId",
                value: 2);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 5,
                column: "BibliotekaId",
                value: 3);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 6,
                column: "BibliotekaId",
                value: 3);

            migrationBuilder.UpdateData(
                table: "TipClanarineBiblioteke",
                keyColumn: "TipClanarineBibliotekaId",
                keyValue: 7,
                column: "BibliotekaId",
                value: 4);

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 1,
                column: "DatumUplate",
                value: new DateTime(2024, 8, 10, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(756));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 2,
                column: "DatumUplate",
                value: new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(761));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 3,
                column: "DatumUplate",
                value: new DateTime(2024, 8, 10, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(764));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 4,
                column: "DatumUplate",
                value: new DateTime(2024, 9, 9, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(768));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 5,
                column: "DatumUplate",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(771));

            migrationBuilder.UpdateData(
                table: "Uplate",
                keyColumn: "UplataId",
                keyValue: 6,
                column: "DatumUplate",
                value: new DateTime(2024, 8, 25, 16, 38, 39, 597, DateTimeKind.Local).AddTicks(774));
        }
    }
}
