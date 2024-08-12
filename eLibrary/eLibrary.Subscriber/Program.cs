// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using eLibrary.Subscriber;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using eLibrary.Model.Messages;

Console.WriteLine("Hello, World!");

//var root = Directory.GetCurrentDirectory();
//var dotenv = Path.Combine(root, ".env");
//DotEnv.Load(dotenv);

DotNetEnv.Env.Load();

var hostname = Environment.GetEnvironmentVariable("_rabbitMqHost") ?? "localhost";
var username = Environment.GetEnvironmentVariable("_rabbitMqUser") ?? "guest";
var password = Environment.GetEnvironmentVariable("_rabbitMqPassword") ?? "guest";

var factory = new ConnectionFactory { HostName = hostname, Password = password, UserName = username };

using var connection = factory.CreateConnection();

using var channel = connection.CreateModel();

channel.QueueDeclare(
    queue: "mail_sending",
    durable:false,
    exclusive:false,
    autoDelete:false,
    arguments:null
    );

Console.WriteLine("Listening...");

var consumer = new EventingBasicConsumer(channel);

consumer.Received += (model, ea) =>
{
    Console.WriteLine("Message received!");  
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);

    Console.WriteLine($"Message content: {message}"); 

    var entity = JsonConvert.DeserializeObject<EmailDTO>(message);
    if (entity != null)
    {
        MailSender.SendEmail(entity!);
        channel.BasicAck(ea.DeliveryTag, false);  // Manualno potvrđivanje
    }
};

channel.BasicConsume(queue: "mail_sending", autoAck: false, consumer: consumer);

//Thread.Sleep(Timeout.Infinite);
Console.WriteLine("Press [enter] to exit");
Console.ReadLine(); 

//var bus = RabbitHutch.CreateBus("host=localhost");

//await bus.PubSub.SubscribeAsync<AutorPretraga>("console_printer", msg =>
//{
//    Console.WriteLine($"Autori pretraga: {msg.Autor.ImeGTE}, {msg.Autor.PrezimeGTE}");
//});
////kopija prethodnog
//await bus.PubSub.SubscribeAsync<AutorPretraga>("console_printer", msg =>
//{
//    Console.WriteLine($"Autori pretraga 2: {msg.Autor.ImeGTE}, {msg.Autor.PrezimeGTE}");
//});

//await bus.PubSub.SubscribeAsync<AutorPretraga>("mail_sender", msg =>
//{
//    Console.WriteLine($"Saljemo Email");
//    //todo send email
//});

Console.WriteLine("Listening for messages, press enter to close!");
Console.ReadLine();
