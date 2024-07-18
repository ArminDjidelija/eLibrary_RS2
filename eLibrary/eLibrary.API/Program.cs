using eLibrary.API.Auth;
using eLibrary.API.Filters;
using eLibrary.Services;
using eLibrary.Services.Database;
using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IJeziciService, JeziciService>();
builder.Services.AddTransient<IAutoriService, AutoriService>();
builder.Services.AddTransient<ICiljneGrupeService, CiljneGrupeService>();
builder.Services.AddTransient<IVrsteSadrzajaService, VrsteSadrzajaService>();
builder.Services.AddTransient<IIzdavaciService, IzdavaciService>();
builder.Services.AddTransient<IValuteService, ValuteService>();
builder.Services.AddTransient<IKantoniService, KantoniService>();
builder.Services.AddTransient<IBibliotekeService, BibliotekeService>();
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IUlogeService, UlogeService>();

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ExceptionFilter>();
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});

var connectionString = builder.Configuration.GetConnectionString("eLibraryConnection");
builder.Services.AddDbContext<ELibraryContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

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
