using System;
using System.Collections.Generic;

namespace BuildResume.DBContext;

public partial class Experience
{
    public int ExperienceId { get; set; }

    public int UserId { get; set; }

    public string CompanyName { get; set; } = null!;

    public DateTime StartDate { get; set; }

    public DateTime EndDate { get; set; }

    public string Role { get; set; } = null!;

    public decimal? ExperienceInYear { get; set; }

    public bool IsDeleted { get; set; }

    public virtual ICollection<Project> Projects { get; set; } = new List<Project>();

    public virtual User User { get; set; } = null!;
}
