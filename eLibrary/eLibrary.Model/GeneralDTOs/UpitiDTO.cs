using eLibrary.Model.CitaociDTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.GeneralDTOs
{
    public class UpitiDTO
    {
        public int UpitId { get; set; }

        public string Naslov { get; set; } 

        public string Upit { get; set; }

        public string? Odgovor { get; set; }

        public int CitalacId { get; set; }
        
    }
}
