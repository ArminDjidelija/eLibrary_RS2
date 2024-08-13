using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.RecommenderDTOs
{
    public class KnjigaPair
    {
        public KnjigaRecommenderDTO Knjiga1 { get; set; }
        public KnjigaRecommenderDTO Knjiga2 { get; set; }
        public bool IsSimilar { get; set; }
    }
}
