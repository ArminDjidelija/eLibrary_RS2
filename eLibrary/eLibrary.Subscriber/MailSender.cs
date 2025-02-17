﻿using MailKit.Net.Smtp;
using MimeKit;

namespace eLibrary.Subscriber
{
    public class MailSender
    {
       public static async Task SendEmail (EmailDTO mailObj)
        {
            if(mailObj == null) return;
            //DotNetEnv.Env.Load();

            string fromAddress = Environment.GetEnvironmentVariable("_fromAddress") ?? "elibrary.rs2@gmail.com";
            string password = Environment.GetEnvironmentVariable("_password") ?? string.Empty;
            string host = Environment.GetEnvironmentVariable("_host") ?? "smtp.gmail.com";
            int port = int.Parse(Environment.GetEnvironmentVariable("_port") ?? "465");
            bool enableSSL = bool.Parse(Environment.GetEnvironmentVariable("_enableSSL") ?? "true");
            string displayName = Environment.GetEnvironmentVariable("_displayName") ?? "no-reply";
            int timeout = int.Parse(Environment.GetEnvironmentVariable("_timeout") ?? "255");
            Console.WriteLine($"Usli smo u metodu prije password: {password}");
            if (password == string.Empty)
            {
                Console.WriteLine("Sifra je prazna");
                return;
            }

            var email = new MimeMessage();

            email.From.Add(new MailboxAddress(displayName, fromAddress));
            email.To.Add(new MailboxAddress(mailObj.ReceiverName, mailObj.EmailTo));

            email.Subject=mailObj.Subject;

            email.Body = new TextPart(MimeKit.Text.TextFormat.Html)
            {
                Text = mailObj.Message
            };

            try
            {
                Console.WriteLine($"Sending email from {fromAddress} to {mailObj.EmailTo}, via port: {port}, at {DateTime.Now}");
                using (var smtp = new SmtpClient())
                {
                    await smtp.ConnectAsync(host, port, enableSSL);
                    await smtp.AuthenticateAsync(fromAddress, password);

                    await smtp.SendAsync(email);
                    await smtp.DisconnectAsync(true);
                }
                Console.WriteLine("Uspjesno poslata poruka");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska SA SLANJEM PORUKA!");

                Console.WriteLine($"Error {ex.Message}");
                return;
            }
        }
    }
}

