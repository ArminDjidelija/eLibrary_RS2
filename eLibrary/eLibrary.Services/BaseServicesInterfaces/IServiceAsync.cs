﻿using eLibrary.Model;
using eLibrary.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.BaseServicesInterfaces
{
    public interface IServiceAsync<TModel, TSearch> where TSearch : BaseSearchObject
    {
        public Task<PagedResult<TModel>> GetPagedAsync(TSearch search, CancellationToken cancellationToken = default);
        public Task<TModel> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        //public Task<TModel> GetFirstOrDefaultForSearchObjectAsync(TSearch search, CancellationToken cancellationToken = default);

    }
}
