using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model
{
    public class KnjigaAutori
    {
        public int KnjigaAutorId { get; set; }

        public int AutorId { get; set; }

        public int KnjigaId { get; set; }
        
        public virtual Knjige Knjiga { get; set; }
    }
}
