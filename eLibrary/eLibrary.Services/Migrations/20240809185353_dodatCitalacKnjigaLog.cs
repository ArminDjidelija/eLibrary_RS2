using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eLibrary.Services.Migrations
{
    /// <inheritdoc />
    public partial class dodatCitalacKnjigaLog : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CitalacKnjigaLogs",
                columns: table => new
                {
                    CitalacKnjigaLogId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    CitalacId = table.Column<int>(type: "int", nullable: false),
                    CitaociCitalacId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CitalacKnjigaLogs", x => x.CitalacKnjigaLogId);
                    table.ForeignKey(
                        name: "FK_CitalacKnjigaLogs_Citaoci_CitaociCitalacId",
                        column: x => x.CitaociCitalacId,
                        principalTable: "Citaoci",
                        principalColumn: "CitalacId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CitalacKnjigaLogs_Knjige_KnjigaId",
                        column: x => x.KnjigaId,
                        principalTable: "Knjige",
                        principalColumn: "KnjigaId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_CitalacKnjigaLogs_CitaociCitalacId",
                table: "CitalacKnjigaLogs",
                column: "CitaociCitalacId");

            migrationBuilder.CreateIndex(
                name: "IX_CitalacKnjigaLogs_KnjigaId",
                table: "CitalacKnjigaLogs",
                column: "KnjigaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CitalacKnjigaLogs");
        }
    }
}
