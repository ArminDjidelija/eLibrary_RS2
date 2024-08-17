using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using eLibrary.Services.Validators.Interfaces;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
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

        public KnjigeService(ELibraryContext context, IMapper mapper,
            IAutoriValidator autoriValidator,
            ICiljneGrupeValidator ciljneGrupeValidator,
            IVrsteSadrzajaValidator vrsteSadrzajaValidator) : base(context, mapper)
        {
            this.autoriValidator = autoriValidator;
            this.ciljneGrupeValidator = ciljneGrupeValidator;
            this.vrsteSadrzajaValidator = vrsteSadrzajaValidator;
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
    }

}
