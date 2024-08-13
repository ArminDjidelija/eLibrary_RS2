using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eLibrary.Services.Migrations
{
    /// <inheritdoc />
    public partial class promjenaCitalacLogs : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CitalacKnjigaLogs_Citaoci_CitaociCitalacId",
                table: "CitalacKnjigaLogs");

            migrationBuilder.DropIndex(
                name: "IX_CitalacKnjigaLogs_CitaociCitalacId",
                table: "CitalacKnjigaLogs");

            migrationBuilder.DropColumn(
                name: "CitaociCitalacId",
                table: "CitalacKnjigaLogs");

            migrationBuilder.CreateIndex(
                name: "IX_CitalacKnjigaLogs_CitalacId",
                table: "CitalacKnjigaLogs",
                column: "CitalacId");

            migrationBuilder.AddForeignKey(
                name: "FK_CitalacKnjigaLogs_Citaoci_CitalacId",
                table: "CitalacKnjigaLogs",
                column: "CitalacId",
                principalTable: "Citaoci",
                principalColumn: "CitalacId",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CitalacKnjigaLogs_Citaoci_CitalacId",
                table: "CitalacKnjigaLogs");

            migrationBuilder.DropIndex(
                name: "IX_CitalacKnjigaLogs_CitalacId",
                table: "CitalacKnjigaLogs");

            migrationBuilder.AddColumn<int>(
                name: "CitaociCitalacId",
                table: "CitalacKnjigaLogs",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_CitalacKnjigaLogs_CitaociCitalacId",
                table: "CitalacKnjigaLogs",
                column: "CitaociCitalacId");

            migrationBuilder.AddForeignKey(
                name: "FK_CitalacKnjigaLogs_Citaoci_CitaociCitalacId",
                table: "CitalacKnjigaLogs",
                column: "CitaociCitalacId",
                principalTable: "Citaoci",
                principalColumn: "CitalacId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
