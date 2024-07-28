// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using eLibrary.Model.Messages;

Console.WriteLine("Hello, World!");

var bus = RabbitHutch.CreateBus("host=localhost");

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
