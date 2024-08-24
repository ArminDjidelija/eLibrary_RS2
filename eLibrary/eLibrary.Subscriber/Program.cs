// See https://aka.ms/new-console-template for more information
using eLibrary.Subscriber;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

//System.Threading.Thread.Sleep(25000); // Wait before retrying

//Console.WriteLine("Pokrećemo aplikaciju!");

////var root = Directory.GetCurrentDirectory();
////var dotenv = Path.Combine(root, ".env");
////DotEnv.Load(dotenv);

//DotNetEnv.Env.Load();

//var hostname = "rabbitmq"; //Environment.GetEnvironmentVariable("_rabbitMqHost") ?? "rabbitmq";
//var username = "guest";  //Environment.GetEnvironmentVariable("_rabbitMqUser") ?? "guest";
//var password = "guest"; //Environment.GetEnvironmentVariable("_rabbitMqPassword") ?? "guest";
//Console.WriteLine($"{hostname}:{username}:{password}");

//var factory = new ConnectionFactory { HostName = hostname, Password = password, UserName = username, VirtualHost = "/"};

//using var connection = factory.CreateConnection();

//using var channel = connection.CreateModel();

//channel.QueueDeclare(
//    queue: "mail_sending",
//    durable:false,
//    exclusive:false,
//    autoDelete: false,
//    arguments: null
//    );

//Console.WriteLine("Listening...");

//var consumer = new EventingBasicConsumer(channel);

//consumer.Received += (model, ea) =>
//{
//    Console.WriteLine("Message received!");  
//    var body = ea.Body.ToArray();
//    var message = Encoding.UTF8.GetString(body);

//    Console.WriteLine($"Message content: {message}"); 

//    var entity = JsonConvert.DeserializeObject<EmailDTO>(message);
//    Console.WriteLine(entity?.EmailTo);
//    if (entity != null)
//    {
//        MailSender.SendEmail(entity!);
//        channel.BasicAck(ea.DeliveryTag, false);  // Manualno potvrđivanje
//    }
//};

//channel.BasicConsume(queue: "mail_sending", autoAck: false, consumer: consumer);

////Thread.Sleep(Timeout.Infinite);
//Console.WriteLine("Press [enter] to exit");
//Console.ReadLine();

//Console.WriteLine("Listening for messages, press enter to close!");
//Console.ReadLine();


Console.WriteLine("Sleeping to wait for Rabbit");
Task.Delay(10000).Wait();
//Console.WriteLine("Posting messages to webApi");
//for (int i = 0; i < 5; i++)
//{
    
//}

Task.Delay(1000).Wait();
Console.WriteLine("Consuming Queue Now");

var hostname = Environment.GetEnvironmentVariable("_rabbitMqHost") ?? "rabbitmq";
var username = Environment.GetEnvironmentVariable("_rabbitMqUser") ?? "guest";
var password = Environment.GetEnvironmentVariable("_rabbitMqPassword") ?? "guest";
var port = int.Parse(Environment.GetEnvironmentVariable("_rabbitMqPort") ?? "5672");

ConnectionFactory factory = new ConnectionFactory() { HostName = hostname, Port = port };
factory.UserName = username;
factory.Password = password;
IConnection conn = factory.CreateConnection();
IModel channel = conn.CreateModel();
channel.QueueDeclare(queue: "mail_sending",
                        durable: false,
                        exclusive: false,
                        autoDelete: false,
                        arguments: null);

var consumer = new EventingBasicConsumer(channel);
consumer.Received += (model, ea) =>
{
    Console.WriteLine("Message received!");
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);

    Console.WriteLine($"Message content: {message}");

    var entity = JsonConvert.DeserializeObject<EmailDTO>(message);
    Console.WriteLine(entity?.EmailTo);
    if (entity != null)
    {
        MailSender.SendEmail(entity!);
        //channel.BasicAck(ea.DeliveryTag, false);  // Manualno potvrđivanje
    }


    //var body = ea.Body;
    //var message = Encoding.UTF8.GetString(body);
    //Console.WriteLine(" [x] Received from Rabbit: {0}", message);
};
channel.BasicConsume(queue: "mail_sending",
                     autoAck: true,
                     consumer: consumer);



Thread.Sleep(Timeout.Infinite);

Console.ReadLine();


//consumer.Received += (model, ea) =>
//{
//    Console.WriteLine("Message received!");
//    var body = ea.Body.ToArray();
//    var message = Encoding.UTF8.GetString(body);

//    Console.WriteLine($"Message content: {message}");

//    var entity = JsonConvert.DeserializeObject<EmailDTO>(message);
//    Console.WriteLine(entity?.EmailTo);
//    if (entity != null)
//    {
//        MailSender.SendEmail(entity!);
//        channel.BasicAck(ea.DeliveryTag, false);  // Manualno potvrđivanje
//    }
//};