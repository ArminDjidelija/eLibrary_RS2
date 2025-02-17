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
    public class UveziService : BaseCRUDServiceAsync<Model.UveziDTOs.Uvezi, UveziSearchObject, Database.Uvezi, UveziUpsertRequest, UveziUpsertRequest>, IUveziService
    {
        public UveziService(ELibraryContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Uvezi> AddFilter(UveziSearchObject search, IQueryable<Uvezi> query)
        {
            if (!string.IsNullOrEmpty(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.Naziv.ToLower()));
            }
            return query;
        }
    }
}
