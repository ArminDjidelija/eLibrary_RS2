namespace eLibrary.Services.Recommender
{
    public interface IRecommendService
    {
        Task<List<Model.KnjigeDTOs.Knjige>> GetRecommendedBooks(int citalacId);
        void TrainData();
    }
}
