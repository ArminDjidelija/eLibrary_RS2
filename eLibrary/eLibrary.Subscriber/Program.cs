﻿// See https://aka.ms/new-console-template for more information
using eLibrary.Subscriber;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

Console.WriteLine("Sleeping to wait for Rabbit");
Task.Delay(10000).Wait();

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
    }
};
channel.BasicConsume(queue: "mail_sending",
                     autoAck: true,
                     consumer: consumer);



Thread.Sleep(Timeout.Infinite);

Console.ReadLine();