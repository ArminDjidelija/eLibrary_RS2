using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.Recommender
{
    public interface IRecommendService
    {
        Task<List<Model.KnjigeDTOs.Knjige>> GetRecommendedBooks(int citalacId);
        void TrainData();
    }
}
