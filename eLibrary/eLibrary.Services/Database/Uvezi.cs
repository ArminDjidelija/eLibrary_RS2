﻿using System;
using System.Collections.Generic;

namespace eLibrary.Services.Database;

public partial class Uvezi : ISoftDeletable
{
    public int UvezId { get; set; }

    public string Naziv { get; set; } = null!;

    public virtual ICollection<Knjige> Knjiges { get; set; } = new List<Knjige>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
