namespace eLibrary.Model.Requests
{
    public class CitaociUpdateRequest
    {
        public string Ime { get; set; }

        public string Prezime { get; set; }

        public string Telefon { get; set; }

        public string? Lozinka { get; set; }

        public string? NovaLozinka { get; set; }

        public string? LozinkaPotvrda { get; set; }

        public string? Institucija { get; set; }

        public int KantonId { get; set; }
    }
}
