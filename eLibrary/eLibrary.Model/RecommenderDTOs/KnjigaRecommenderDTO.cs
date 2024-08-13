using Microsoft.ML.Data;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.RecommenderDTOs
{
    public class KnjigaRecommenderDTO
    {
        public int KnjigaId { get; set; }
        public string Naslov {  get; set; }
        public string Jezik { get; set; }

        [VectorType(10)]
        public float[] AutoriEmbedding { get; set; }

        [VectorType(10)]
        public float[] CiljneGrupeEmbedding { get; set; }

        [VectorType(10)]
        public float[] VrsteSadrzajaEmbedding { get; set; }
    }
}
