using System;
using System.Collections.Generic;

namespace BuildResume.DBContext;

public partial class ProjLangDetail
{
    public int ProjLangDetailId { get; set; }

    public int? UserId { get; set; }

    public int? ProjectId { get; set; }

    public int ProjectLanguageId { get; set; }

    public bool IsDeleted { get; set; }

    public virtual Project? Project { get; set; }

    public virtual ProjectLanguage ProjectLanguage { get; set; } = null!;

    public virtual User? User { get; set; }
}
