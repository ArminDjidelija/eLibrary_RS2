using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eLibrary.Model.Exceptions;
using eLibrary.Model.Requests;
using eLibrary.Services.Database;
using eLibrary.Services.Validators.Interfaces;

namespace eLibrary.Services.Validators.Implementation
{
    public class KorisniciValidator : BaseValidatorService<Database.Korisnici>, IKorisniciValidator
    {
        private readonly ELibraryContext context;

        public KorisniciValidator(ELibraryContext context) : base(context)
        {
            this.context = context;
        }

  
    }
}
