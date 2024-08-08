using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eLibrary.Services.Migrations
{
    /// <inheritdoc />
    public partial class dodataValutaZaPenal : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ValutaId",
                table: "Penali",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Penali_ValutaId",
                table: "Penali",
                column: "ValutaId");

            migrationBuilder.AddForeignKey(
                name: "FK_Penali_Valute_ValutaId",
                table: "Penali",
                column: "ValutaId",
                principalTable: "Valute",
                principalColumn: "ValutaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Penali_Valute_ValutaId",
                table: "Penali");

            migrationBuilder.DropIndex(
                name: "IX_Penali_ValutaId",
                table: "Penali");

            migrationBuilder.DropColumn(
                name: "ValutaId",
                table: "Penali");
        }
    }
}
