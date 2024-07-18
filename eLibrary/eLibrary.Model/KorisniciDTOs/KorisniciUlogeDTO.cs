using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KorisniciDTOs
{
    public class KorisniciUlogeDTO
    {
        public int KorisnikUlogaId { get; set; }

        public int UlogaId { get; set; }

        public int KorisnikId { get; set; }

        public UlogeDTOs.Uloge? Uloga { get; set; }
    }
}
