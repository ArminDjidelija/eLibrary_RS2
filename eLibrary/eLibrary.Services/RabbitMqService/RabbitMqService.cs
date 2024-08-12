using eLibrary.Model.Messages;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services.RabbitMqService
{
    public class RabbitMqService : IRabbitMqService
    {
        public async Task SendAnEmail(EmailDTO mail)
        {
            var hostname = Environment.GetEnvironmentVariable("_rabbitMqHost") ?? "localhost";
            var username = Environment.GetEnvironmentVariable("_rabbitMqUser") ?? "guest";
            var password = Environment.GetEnvironmentVariable("_rabbitMqPassword") ?? "guest";

            var factory = new ConnectionFactory { HostName = hostname, UserName = username, Password = password };
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "mail_sending",
                              durable: false,
                              exclusive: false,
                              autoDelete: false,
                              arguments: null);

            var body = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(mail));

            channel.BasicPublish(exchange: string.Empty,
                              routingKey: "mail_sending",
                              basicProperties: null,
                              body: body);
        }
    }
}
