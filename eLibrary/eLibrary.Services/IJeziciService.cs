﻿using eLibrary.Model;
using eLibrary.Model.Requests;
using eLibrary.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eLibrary.Services
{
    public interface IJeziciService:ICRUDService<Jezici, JeziciSearchObject, JeziciUpsertRequest, JeziciUpsertRequest>
    {

    }
}
