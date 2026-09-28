using System;
using System.Collections.Generic;

namespace BuildResume.DBContext;

public partial class Project
{
    public int ProjectId { get; set; }

    public int? UserId { get; set; }

    public int? ExperienceId { get; set; }

    public string ProjectName { get; set; } = null!;

    public string Role { get; set; } = null!;

    public string TechnologyNames { get; set; } = null!;

    public DateTime StartDate { get; set; }

    public DateTime EndDate { get; set; }

    public bool IsDeleted { get; set; }

    public virtual Experience? Experience { get; set; }

    public virtual ICollection<ProjLangDetail> ProjLangDetails { get; set; } = new List<ProjLangDetail>();

    public virtual User? User { get; set; }
}
