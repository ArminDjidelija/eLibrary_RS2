﻿using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class UplateService : BaseCRUDServiceAsync<Model.UplateDTOs.Uplate, UplateSearchObject, Database.Uplate, UplateInsertRequest, UplateUpdateRequest>, IUplateService
    {
        public UplateService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Uplate> AddFilter(UplateSearchObject search, IQueryable<Uplate> query)
        {
            if(search?.CitalacId!= null)
            {
                query=query.Where(x=>x.CitalacId==search.CitalacId);
            }
            if (search?.BibliotekaId != null)
            {
                query = query.Where(x => x.BibliotekaId == search.BibliotekaId);
            }
            if (search?.ValutaId != null)
            {
                query = query.Where(x => x.ValutaId == search.ValutaId);
            }
            if(search?.DatumUplateGTE != null)
            {
                query = query.Where(x => x.DatumUplate > search.DatumUplateGTE);
            }
            if (search?.DatumUplateLTE != null)
            {
                query = query.Where(x => x.DatumUplate < search.DatumUplateLTE);
            }

            if(search?.IznosGTE != null)
            {
                query=query.Where(x=>x.Iznos>search.IznosGTE);
            }
            if (search?.IznosLTE != null)
            {
                query = query.Where(x => x.Iznos < search.IznosLTE);
            }
            return query;
        }

        public override async Task BeforeInsertAsync(UplateInsertRequest request, Uplate entity, CancellationToken cancellationToken = default)
        {
            if (request.DatumUplate == null)
            {
                entity.DatumUplate = DateTime.Now;
            }
        }
    }
}