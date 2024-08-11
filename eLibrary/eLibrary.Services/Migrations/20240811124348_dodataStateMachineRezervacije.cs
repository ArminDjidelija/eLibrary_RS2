using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eLibrary.Services.Migrations
{
    /// <inheritdoc />
    public partial class dodataStateMachineRezervacije : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "State",
                table: "Rezervacije",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "State",
                table: "Rezervacije");
        }
    }
}
