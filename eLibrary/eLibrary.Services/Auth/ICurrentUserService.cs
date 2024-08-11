namespace eLibrary.Services.Auth
{
    public interface ICurrentUserService
    {
        int? GetUserId();
        string? GetUserName();
        string? GetUserType();
        int? GetCitaocId();
        int GetBibliotekaIdFromUser();
    }
}
