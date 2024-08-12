using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.RecommenderDTOs
{
    public class KnjigaRecommenderDTO
    {
        public int Id { get; set; }
        public float[] AutoriFeatures { get; set; }
        public float[] CiljneGrupeFeatures { get; set; }
        public float[] VrsteSadrzajaFeatures { get; set; }
    }
}
