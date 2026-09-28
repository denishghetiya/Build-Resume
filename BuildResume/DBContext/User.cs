using System;
using System.Collections.Generic;

namespace BuildResume.DBContext;

public partial class User
{
    public int UserId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public long PhoneNumber { get; set; }

    public string Email { get; set; } = null!;

    public string? Template { get; set; }

    public bool IsDeleted { get; set; }

    public virtual ICollection<Experience> Experiences { get; set; } = new List<Experience>();

    public virtual ICollection<ProjLangDetail> ProjLangDetails { get; set; } = new List<ProjLangDetail>();

    public virtual ICollection<Project> Projects { get; set; } = new List<Project>();
}
