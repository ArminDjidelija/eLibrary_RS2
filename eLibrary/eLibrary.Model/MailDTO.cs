using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Subscriber
{
    public class MailDTO
    {
        public string EmailTo { get; set; } 
        public string ReceiverName { get; set; }
        public string Subject { get; set; } 
        public string Message { get; set; } 
    }
}
