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
    public class CiljneGrupeValidator : BaseValidatorService<Database.CiljneGrupe>, ICiljneGrupeValidator
    {
        private readonly ELibraryContext context;

        public CiljneGrupeValidator(ELibraryContext context) : base(context)
        {
            this.context = context;
        }
    }
}
