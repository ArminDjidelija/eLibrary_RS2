using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.Auth
{
    public interface ICurrentUserService
    {
        int? GetUserId();
        string? GetUserName();
        string? GetUserType();
        int? GetCitaocId();
    }
}
