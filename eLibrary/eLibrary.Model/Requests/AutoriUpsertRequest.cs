using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class AutoriUpsertRequest
    {
        public string Ime { get; set; }
        public string Prezime { get; set; }
        public int? GodinaRodjenja { get; set; }
    }
}
