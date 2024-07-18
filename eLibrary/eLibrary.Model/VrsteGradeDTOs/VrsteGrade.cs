using System.Collections.Generic;

namespace eLibrary.Model.VrsteGradeDTOs
{
    public class VrsteGrade
    {
        public int VrstaGradeId { get; set; }

        public string Naziv { get; set; }

        public virtual ICollection<GeneralDTOs.KnjigeDTO> Knjiges { get; set; } = new List<GeneralDTOs.KnjigeDTO>();
    }
}
