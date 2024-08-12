using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.RecommenderDTOs
{
    public class KnjigaFeatureVector
    {
        public float[] AutoriFeatures {  get; set; }
        public float[] CiljneGrupeFeatures {  get; set; }
        public float[] VrsteSadrzajaFeatures {  get; set; }
    }
}
