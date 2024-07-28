using eLibrary.Model.Requests;
using eLibrary.Services.IBaseValidator;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.Validators.Interfaces
{
    public interface IJeziciValidator : IBaseValidator<Database.Jezici>
    {
    }
}
