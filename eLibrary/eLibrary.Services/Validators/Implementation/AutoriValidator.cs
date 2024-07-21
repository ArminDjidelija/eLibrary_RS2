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
    public class AutoriValidator : BaseValidatorService<Database.Autori>, IAutoriValidator
    {
        private readonly ELibraryContext context;

        public AutoriValidator(ELibraryContext context) : base(context)
        {
            this.context = context;
        }

        public void ValidateAutorNaziv(AutoriUpsertRequest autor)
        {
            var obj = context.Autoris.Where(x => x.Ime == autor.Ime && x.Prezime == autor.Prezime && x.GodinaRodjenja == autor.GodinaRodjenja).FirstOrDefault();
            if (obj != null)
            {
                throw new UserException($"Autor {autor.Ime} {autor.Prezime} rodjen {autor.GodinaRodjenja}. godine već postoji!");
            }
        }

        public void ValidateNoDuplicates(List<int> array)
        {
            if (array.Count() > 0)
            {
                if (array.Count() != array.Distinct().Count())
                {
                    throw new UserException("Lista autora ima duplikate!");
                }
            }
        }
    }
}
