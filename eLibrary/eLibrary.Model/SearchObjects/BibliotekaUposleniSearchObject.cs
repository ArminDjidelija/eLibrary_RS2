﻿using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class BibliotekaUposleniSearchObject:BaseSearchObject
    {
        public int? KorisnikId { get; set; }

        public int? BibliotekaId { get; set; }

        public string? ImePrezimeGTE { get; set; }

        public string? EmailGTE { get; set; }
    }
}
