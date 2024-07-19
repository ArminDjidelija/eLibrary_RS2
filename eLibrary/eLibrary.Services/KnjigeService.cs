using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
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
        public KnjigeService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Knjige> AddFilter(KnjigeSearchObject search, IQueryable<Knjige> query)
        {
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
                query=query.Where(x=>x.Isbn==search.Isbn);
            }

            if (search?.IzdavacId != null)
            {
                query=query.Where(x=>x.IzdavacId==search.IzdavacId);
            }
            if (search?.JezikId != null)
            {
                query=query.Where(x=>x.JezikId==search.JezikId);
            }

            return query;
            
        }

        public override async Task BeforeInsertAsync(KnjigeInsertRequest request, Knjige entity, CancellationToken cancellationToken = default)
        {
            if(!string.IsNullOrEmpty(request?.SlikaBase64))
            {
                string base64Data = request.SlikaBase64;
                if (base64Data.Contains(","))
                {
                    base64Data = base64Data.Substring(base64Data.IndexOf(",") + 1);
                }

                entity.Slika = Convert.FromBase64String(base64Data);
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
            if (!string.IsNullOrEmpty(request?.SlikaBase64))
            {
                string base64Data = request.SlikaBase64;
                if (base64Data.Contains(","))
                {
                    base64Data = base64Data.Substring(base64Data.IndexOf(",") + 1);
                }

                entity.Slika = Convert.FromBase64String(base64Data);
            }
        }

    }
}
