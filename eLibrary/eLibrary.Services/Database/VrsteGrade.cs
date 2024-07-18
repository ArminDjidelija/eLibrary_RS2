using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.Database
{
    public class VrsteGrade:ISoftDeletable
    {
        public int VrstaGradeId { get; set; }

        public string Naziv { get; set; }

        public virtual ICollection<Knjige> Knjiges { get; set; } = new List<Knjige>();

        public bool IsDeleted { get; set; } = false;
        public DateTime? VrijemeBrisanja { get; set; }

    }
}
