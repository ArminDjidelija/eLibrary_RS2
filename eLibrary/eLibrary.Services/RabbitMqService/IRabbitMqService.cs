
namespace eLibrary.Services.RabbitMqService
{
    public interface IRabbitMqService
    {
        Task SendAnEmail(Model.Messages.EmailDTO mail);
    }
}
