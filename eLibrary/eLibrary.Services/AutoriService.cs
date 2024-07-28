using EasyNetQ;
using eLibrary.Model.Messages;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using eLibrary.Services.Auth;
using eLibrary.Services.BaseServices;
using eLibrary.Services.Database;
using eLibrary.Services.Validators.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public class AutoriService : BaseCRUDServiceAsync<Model.AutoriDTOs.Autori, AutoriSearchObject, Database.Autori, AutoriUpsertRequest, AutoriUpsertRequest>, IAutoriService
    {
        private readonly ICurrentUserService userService;
        private readonly IAutoriValidator autoriValidator;

        public AutoriService(ELibraryContext context, IMapper mapper, 
            ICurrentUserService userService,
            IAutoriValidator autoriValidator) : base(context, mapper)
        {
            this.userService = userService;
            this.autoriValidator = autoriValidator;
        }

        public override IQueryable<Database.Autori> AddFilter(AutoriSearchObject search, IQueryable<Database.Autori> query)
        {
            //var bus = RabbitHutch.CreateBus("host=localhost");
            //bus.PubSub.Publish(new AutorPretraga { Autor=search});
            

            if (!string.IsNullOrEmpty(search?.ImeGTE))
            {
                query=query.Where(x=>x.Ime.ToLower().StartsWith(search.ImeGTE.ToLower()));    
            }
            if (!string.IsNullOrEmpty(search?.PrezimeGTE))
            {
                query = query.Where(x => x.Prezime.ToLower().StartsWith(search.PrezimeGTE.ToLower()));
            }
            if (search?.GodinaRodjenjaGTE != null)
            {
                query = query.Where(x => x.GodinaRodjenja>search.GodinaRodjenjaGTE);
            }
            if (search?.GodinaRodjenjaGTE != null)
            {
                query = query.Where(x => x.GodinaRodjenja < search.GodinaRodjenjaGTE);
            }
            if (string.IsNullOrEmpty(search?.ImeGTE) && string.IsNullOrEmpty(search?.PrezimeGTE) && !string.IsNullOrEmpty(search?.ImePrezimeGTE))
            {
                query = query
                    .Where(x => 
                    (x.Ime+" "+x.Prezime).ToLower().StartsWith(search.ImePrezimeGTE));
            }
            return query;
        }

        public override async Task BeforeInsertAsync(AutoriUpsertRequest request, Autori entity, CancellationToken cancellationToken = default)
        {
            autoriValidator.ValidateAutorNaziv(request);
        }

    }
}
