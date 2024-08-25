using eLibrary.API.Auth;
using eLibrary.API.Filters;
using eLibrary.Services;
using eLibrary.Services.Auth;
using eLibrary.Services.Database;
using eLibrary.Services.RabbitMqService;
using eLibrary.Services.Recommender;
using eLibrary.Services.RezervacijeStateMachine;
using eLibrary.Services.Validators.Implementation;
using eLibrary.Services.Validators.Interfaces;
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
builder.Services.AddTransient<ITipClanarineBibliotekeService, TipClanarineBibliotekeService>();
builder.Services.AddTransient<IUveziService, UveziService>();
builder.Services.AddTransient<IVrsteGradeService, VrsteGradeService>();
builder.Services.AddTransient<IKnjigaAutoriService, KnjigaAutoriService>();
builder.Services.AddTransient<ITipoviUplatumService, TipoviUplatumService>();
builder.Services.AddTransient<IBibliotekaKnjigeService, BibliotekaKnjigeService>();
builder.Services.AddTransient<IKnjigaVrsteSadrzajaService, KnjigaVrsteSadrzajaService>();
builder.Services.AddTransient<IKnjigaCiljneGrupeService, KnjigaCiljneGrupeService>();
builder.Services.AddTransient<IKnjigeService, KnjigeService>();
builder.Services.AddTransient<IBibliotekaUposleniService, BibliotekaUposleniService>();
builder.Services.AddTransient<ICitaociService, CitaociService>();
builder.Services.AddTransient<IUpitiService, UpitiService>();
builder.Services.AddTransient<IKorisnikSacuvanaKnjigaService, KorisnikSacuvaneKnjigeService>();
builder.Services.AddTransient<IPozajmiceService, PozajmiceService>();
builder.Services.AddTransient<IUplateService, UplateService>();
builder.Services.AddTransient<IClanarineService, ClanarineService>();
builder.Services.AddTransient<IPenaliService, PenaliService>();
builder.Services.AddTransient<IObavijestiService, ObavijestiService>();
builder.Services.AddTransient<IRezervacijeService, RezervacijeService>();
builder.Services.AddTransient<IBibliotekaCitaociZabraneService, BibliotekaCitaociZabraneService>();
builder.Services.AddTransient<IProduzenjePozajmicaService, ProduzenjePozajmicaService>();
builder.Services.AddTransient<ICitalacKnjigaLogService, CitalacKnjigaLogService>();

builder.Services.AddTransient<IAutoriValidator, AutoriValidator>();
builder.Services.AddTransient<IUlogeValidator, UlogeValidator>();
builder.Services.AddTransient<IKnjigeValidator, KnjigeValidator>();
builder.Services.AddTransient<IVrsteSadrzajaValidator, VrsteSadrzajaValidator>();
builder.Services.AddTransient<ICiljneGrupeValidator, CiljneGrupeValidator>();
builder.Services.AddTransient<IJeziciValidator, JeziciValidator>();
builder.Services.AddTransient<IKorisniciValidator, KorisniciValidator>();

builder.Services.AddTransient<BaseRezervacijeState>();
builder.Services.AddTransient<InitialRezervacijaState>();
builder.Services.AddTransient<PonistenaRezervacijaState>();
builder.Services.AddTransient<OdobrenaRezervacijaState>();
builder.Services.AddTransient<ObnovljenaRezervacijaState>();
builder.Services.AddTransient<KreiranaRezervacijaState>();
builder.Services.AddTransient<ZavrsenaRezervacijaState>();


builder.Services.AddScoped<ICurrentUserServiceAsync, CurrentUserServiceAsync>();
builder.Services.AddScoped<ICurrentUserService, CurrentUserService>();
builder.Services.AddScoped<IPasswordService, PasswordService>();
builder.Services.AddScoped<IRabbitMqService, RabbitMqService>();
builder.Services.AddScoped<IRecommendService, RecommendService>();

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

DotNetEnv.Env.Load();

var connectionString = builder.Configuration.GetConnectionString("eLibraryConnection");
builder.Services.AddDbContext<ELibraryContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
builder.Services.AddHttpContextAccessor();

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

using(var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<ELibraryContext>();
    //dataContext.Database.EnsureCreated();
    dataContext.Database.Migrate();

    //try
    //{
    //}
    //catch (Exception ex) { }

}

app.Run();
