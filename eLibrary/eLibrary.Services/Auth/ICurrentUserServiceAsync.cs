namespace eLibrary.Services.Auth
{
    public interface ICurrentUserServiceAsync
    {
        Task<int?> GetUserIdAsync(CancellationToken cancellationToken=default);
        Task<string?> GetUserNameAsync(CancellationToken cancellationToken = default);
        Task<string?> GetUserTypeAsync(CancellationToken cancellationToken = default);
        Task<int?> GetCitaocIdAsync(CancellationToken cancellationToken = default);
        Task<int> GetBibliotekaIdFromUserAsync(CancellationToken cancellationToken = default);
    }
}
