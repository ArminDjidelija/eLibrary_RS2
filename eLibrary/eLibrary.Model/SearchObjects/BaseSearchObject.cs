﻿using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.SearchObjects
{
    public class BaseSearchObject
    {
        public int? Page { get; set; }
        public int? PageSize { get; set; }
        public bool? RetrieveAll { get; set; }
    }
}
