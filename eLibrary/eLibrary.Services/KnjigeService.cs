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
        private readonly ICurrentUserServiceAsync currentUserService;

        public KnjigeService(ELibraryContext context, IMapper mapper,
            IAutoriValidator autoriValidator,
            ICiljneGrupeValidator ciljneGrupeValidator,
            IVrsteSadrzajaValidator vrsteSadrzajaValidator,
            ICurrentUserServiceAsync currentUserService) : base(context, mapper)
        {
            this.autoriValidator = autoriValidator;
            this.ciljneGrupeValidator = ciljneGrupeValidator;
            this.vrsteSadrzajaValidator = vrsteSadrzajaValidator;
            this.currentUserService = currentUserService;
        }

        public override IQueryable<Knjige> AddFilter(KnjigeSearchObject search, IQueryable<Knjige> query)
        {
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
            if (!string.IsNullOrEmpty(search?.Isbn))
            {
                query = query
                         .Where(x => x.Isbn == search.Isbn ||
                         (x.Isbn.Replace("-", "") == search.Isbn));
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
            //if (!string.IsNullOrEmpty(request?.Slika))
            //{              
            //    string base64Data = request.Slika;
            //    if (base64Data.Contains(","))
            //    {
            //        base64Data = base64Data.Substring(base64Data.IndexOf(",") + 1);
            //    }

            //    entity.Slika = Convert.FromBase64String(base64Data);
            //}
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

        public override async Task<Model.KnjigeDTOs.Knjige> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var citalacId = await currentUserService.GetCitaocIdAsync();
            if (citalacId != null)
            {
                await Context.CitalacKnjigaLogs.AddAsync(new CitalacKnjigaLog
                {
                    KnjigaId=id,
                    CitalacId=citalacId.Value
                });
            }
            return await base.GetByIdAsync(id, cancellationToken);
        }
        public override async Task BeforeUpdateAsync(KnjigeUpdateRequest request, Knjige entity, CancellationToken cancellationToken = default)
        {
            //if (!string.IsNullOrEmpty(request?.Slika))
            //{
            //    string base64Data = request.Slika;
            //    if (base64Data.Contains(","))
            //    {
            //        base64Data = base64Data.Substring(base64Data.IndexOf(",") + 1);
            //    }

            //    entity.Slika = Convert.FromBase64String(base64Data);
            //}
        }

    }
}
