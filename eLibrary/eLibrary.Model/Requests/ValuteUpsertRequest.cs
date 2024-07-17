using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class ValuteUpsertRequest
    {
        public string Naziv { get; set; }

        public string? Skracenica { get; set; }
    }
}
