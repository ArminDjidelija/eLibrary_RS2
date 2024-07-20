using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Requests
{
    public class PozajmiceUpdateRequest
    {
        public DateTime DatumPreuzimanja { get; set; }

        public DateTime PreporuceniDatumVracanja { get; set; }

        public DateTime? StvarniDatumVracanja { get; set; }

        public int Trajanje { get; set; }

        public bool MoguceProduziti { get; set; }
    }
}
