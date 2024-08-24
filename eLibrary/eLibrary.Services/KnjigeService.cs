using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using eLibrary.Services.Validators.Interfaces;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class KnjigeService : BaseCRUDServiceAsync<Model.KnjigeDTOs.Knjige, KnjigeSearchObject, Database.Knjige, KnjigeInsertRequest, KnjigeUpdateRequest>, IKnjigeService
    {
        private readonly IAutoriValidator autoriValidator;
        private readonly ICiljneGrupeValidator ciljneGrupeValidator;
        private readonly IVrsteSadrzajaValidator vrsteSadrzajaValidator;
        private readonly IKnjigaAutoriService knjigaAutoriService;
        private readonly IKnjigaVrsteSadrzajaService knjigaVrsteSadrzajaService;
        private readonly IKnjigaCiljneGrupeService knjigaCiljneGrupeService;

        public KnjigeService(ELibraryContext context, IMapper mapper,
            IAutoriValidator autoriValidator,
            ICiljneGrupeValidator ciljneGrupeValidator,
            IVrsteSadrzajaValidator vrsteSadrzajaValidator,
            IKnjigaAutoriService knjigaAutoriService,
            IKnjigaVrsteSadrzajaService knjigaVrsteSadrzajaService,
            IKnjigaCiljneGrupeService knjigaCiljneGrupeService) : base(context, mapper)
        {
            this.autoriValidator = autoriValidator;
            this.ciljneGrupeValidator = ciljneGrupeValidator;
            this.vrsteSadrzajaValidator = vrsteSadrzajaValidator;
            this.knjigaAutoriService = knjigaAutoriService;
            this.knjigaVrsteSadrzajaService = knjigaVrsteSadrzajaService;
            this.knjigaCiljneGrupeService = knjigaCiljneGrupeService;
        }

        public override IQueryable<Knjige> AddFilter(KnjigeSearchObject search, IQueryable<Knjige> query)
        {
            if (!string.IsNullOrEmpty(search?.IsbnGTE))
            {
                query = query
                    .Where(x => x.Isbn.Replace("-", "").StartsWith(search.IsbnGTE.Replace("-", "")));
            }
            if (search?.KnjigaId != null)
            {
                query=query.Where(x=>x.KnjigaId==search.KnjigaId);  
            }
            if (!string.IsNullOrEmpty(search?.NaslovGTE))
            {
                query = query.Where(x => x.Naslov.ToLower().StartsWith(search.NaslovGTE));
            }

            if (!string.IsNullOrEmpty(search?.Autor))
            {
                query = query
                    .Include(x => x.KnjigaAutoris)
                    .ThenInclude(x => x.Autor)
                    .Where(x =>
                        (x.KnjigaAutoris
                        .Where(
                            y => (y.Autor.Ime + " " + y.Autor.Prezime).ToLower().StartsWith(search.Autor))
                            .Count() > 0));
            }
            if (search?.BrojStranicaGTE != null)
            {
                query=query.Where(x=>x.BrojStranica>search.BrojStranicaGTE);
            }
            if(search?.BrojStranicaLTE != null)
            {
                query = query.Where(x => x.BrojStranica < search.BrojStranicaLTE);
            }

            if (search?.IzdavacId != null)
            {
                query=query.Where(x=>x.IzdavacId==search.IzdavacId);
            }
            if (search?.JezikId != null)
            {
                query=query.Where(x=>x.JezikId==search.JezikId);
            }

            if (search?.BibliotekaId!=null)
            {
                query = query
                    .Include(k=>k.BibliotekaKnjiges)
                    .Where(x => x.BibliotekaKnjiges.Any(bk=>bk.BibliotekaId==search.BibliotekaId));
            }

            if(search?.VrsteGradeId != null)
            {
                query = query
                    .Where(x=> x.VrsteGradeId==search.VrsteGradeId);
            }

            //query = query.Include(x => x.KnjigaAutoris).ThenInclude(x => x.Autor);

            return query;
            
        }

        public override async Task BeforeInsertAsync(KnjigeInsertRequest request, Knjige entity, CancellationToken cancellationToken = default)
        {
            if (request?.Autori != null)
            {
                autoriValidator.ValidateNoDuplicates(request.Autori);
                foreach (var item in request.Autori)
                {
                    autoriValidator.ValidateEntityExists(item);
                }
            }

            if (request?.CiljneGrupe != null)
            {
                ciljneGrupeValidator.ValidateNoDuplicates(request.CiljneGrupe);

                foreach (var item in request.CiljneGrupe)
                {
                    ciljneGrupeValidator.ValidateEntityExists(item);
                }
            }

            if (request?.VrsteSadrzaja != null)
            {
                vrsteSadrzajaValidator.ValidateNoDuplicates(request.VrsteSadrzaja);

                foreach (var item in request.VrsteSadrzaja)
                {
                    vrsteSadrzajaValidator.ValidateEntityExists(item);
                }
            }
        }

        public override async Task AfterInsertAsync(KnjigeInsertRequest request, Knjige entity, CancellationToken cancellationToken = default)
        {
            if (request?.Autori!=null)
            {
                foreach (var autorId in request.Autori)
                {
                    Context.KnjigaAutoris.Add(new KnjigaAutori
                    {
                        AutorId = autorId,
                        KnjigaId = entity.KnjigaId,
                    });
                }
                await Context.SaveChangesAsync(cancellationToken);
            }

            if (request?.CiljneGrupe != null)
            {
                foreach (var ciljnaGrupaId in request.CiljneGrupe)
                {
                    Context.KnjigaCiljneGrupes.Add(new KnjigaCiljneGrupe
                    {
                        CiljnaGrupaId = ciljnaGrupaId,
                        KnjigaId = entity.KnjigaId,
                    });
                }
                await Context.SaveChangesAsync(cancellationToken);
            }

            if (request?.VrsteSadrzaja != null)
            {
                foreach (var vrstaId in request.VrsteSadrzaja)
                {
                    Context.KnjigaVrsteSadrzajas.Add(new KnjigaVrsteSadrzaja
                    {
                        VrstaSadrzajaId=vrstaId,
                        KnjigaId = entity.KnjigaId,
                    });
                }
                await Context.SaveChangesAsync(cancellationToken);
            }
        }

        public override async Task BeforeUpdateAsync(KnjigeUpdateRequest request, Knjige entity, CancellationToken cancellationToken = default)
        {
            var knjigaAutori = await Context
                .KnjigaAutoris
                .Where(x => x.KnjigaId == entity.KnjigaId)
                .ToListAsync(cancellationToken);

            var knjigaCiljneGrupe = await Context
                .KnjigaCiljneGrupes
                .Where(x => x.KnjigaId == entity.KnjigaId)
                .ToListAsync(cancellationToken);

            var knjigaVrsteSadrzaja = await Context
                .KnjigaVrsteSadrzajas
                .Where(x => x.KnjigaId == entity.KnjigaId)
                .ToListAsync(cancellationToken);

            if (request.Autori.IsNullOrEmpty() || request.CiljneGrupe.IsNullOrEmpty() || request.VrsteSadrzaja.IsNullOrEmpty())
                throw new UserException("Autori, ciljne grupe i vrste sadrzaja moraju imati vrijednost!");

            //novi podaci koje je potrebno dodati
            var noviAutori = request
                .Autori
                .Where(x => !knjigaAutori.Select(x=>x.AutorId).Contains(x)).ToList();

            var noveCiljneGrupe = request
                .CiljneGrupe
                .Where(x => !knjigaCiljneGrupe.Select(x=>x.CiljnaGrupaId).Contains(x)).ToList();

            var noveVrsteSadrzaja = request
                .VrsteSadrzaja
                .Where(x => !knjigaVrsteSadrzaja.Select(x=>x.VrstaSadrzajaId).Contains(x)).ToList();

            //stari podaci koji nisu aktuelni vise
            var nepotrebniAutori = knjigaAutori
                .Where(x => !request.Autori.Contains(x.AutorId)).ToList();

            var nepotrebneCiljneGrupe = knjigaCiljneGrupe
                .Where(x => !request.CiljneGrupe.Contains(x.CiljnaGrupaId)).ToList();

            var nepotrebneVrsteSadrzaja = knjigaVrsteSadrzaja
                .Where(x => !request.VrsteSadrzaja.Contains(x.VrstaSadrzajaId)).ToList();

            foreach ( var x in noviAutori)
            {
                await knjigaAutoriService.InsertAsync(new KnjigaAutoriUpsertRequest 
                { 
                    AutorId = x,
                    KnjigaId = entity.KnjigaId 
                });
            }

            foreach (var x in noveCiljneGrupe)
            {
                await knjigaCiljneGrupeService.InsertAsync(new KnjigaCiljneGrupeInsertRequest
                {
                    CiljnaGrupaId = x,
                    KnjigaId = entity.KnjigaId
                });
            }

            foreach (var x in noveVrsteSadrzaja)
            {
                await knjigaVrsteSadrzajaService.InsertAsync(new KnjigaVrsteSadrzajaInsertRequest
                {
                    VrstaSadrzajaId = x,
                    KnjigaId = entity.KnjigaId
                });
            }

            foreach(var x in nepotrebniAutori)
            {
                await knjigaAutoriService.DeleteAsync(x.KnjigaAutorId);
            }

            foreach (var x in nepotrebneVrsteSadrzaja)
            {
                await knjigaVrsteSadrzajaService.DeleteAsync(x.KnjigaVrstaSadrzajaId);
            }

            foreach (var x in nepotrebneCiljneGrupe)
            {
                await knjigaCiljneGrupeService.DeleteAsync(x.KnjigaCiljnaGrupaId);
            }

            await Context.SaveChangesAsync(cancellationToken);
        }
    }

}
