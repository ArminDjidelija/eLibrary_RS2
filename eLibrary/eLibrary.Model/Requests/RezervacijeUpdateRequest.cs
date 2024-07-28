using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class RezervacijeUpdateRequest
    {
        public bool? Odobreno { get; set; }

        public int? TrajanjeRezervacije { get; set; }

        //public bool? Ponistena { get; set; }
    }
}
