﻿using System;
using System.Collections.Generic;
using System.Text;

namespace eLibrary.Model.Exceptions
{
    public class UserException:Exception
    {
        public UserException(string message):base(message) { }
    }
}
