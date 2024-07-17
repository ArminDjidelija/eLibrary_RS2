using eLibrary.Services;
using eLibrary.Services.Database;
using Mapster;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IJeziciService, JeziciService>();
builder.Services.AddTransient<IAutoriService, AutoriService>();
builder.Services.AddTransient<ICiljneGrupeService, CiljneGrupeService>();
builder.Services.AddTransient<IVrsteSadrzajaService, VrsteSadrzajaService>();
builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("eLibraryConnection");
builder.Services.AddDbContext<ELibraryContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
