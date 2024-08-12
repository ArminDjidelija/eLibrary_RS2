using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.RecommenderDTOs
{
    public class RecommendedKnjiga
    {
        public KnjigeDTOs.Knjige Knjiga { get; set; }
        public float Score { get; set; }
    }
}
