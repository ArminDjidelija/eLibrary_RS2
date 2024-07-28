using eLibrary.Model.AutoriDTOs;
using eLibrary.Model.KnjigeDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.KnjigaAutoriDTOs
{
    public class KnjigaAutori
    {
        public int KnjigaAutorId { get; set; }

        public int AutorId { get; set; }

        public int KnjigaId { get; set; }

        public virtual GeneralDTOs.AutoriDTO? Autor { get; set; }

        public virtual GeneralDTOs.KnjigeDTO? Knjiga { get; set; }
    }
}
