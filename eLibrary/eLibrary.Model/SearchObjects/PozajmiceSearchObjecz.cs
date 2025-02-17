﻿using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class PozajmiceSearchObject:BaseSearchObject
    {
        public int? CitalacId { get; set; }

        public int? BibliotekaKnjigaId { get; set; }

        public string? ImePrezimeGTE { get; set; }

        public string? NaslovGTE { get; set; }

        public bool? Vraceno { get; set; }

        public int? BibliotekaId { get; set; }
    }
}
