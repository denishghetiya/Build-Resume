using System;
using System.Collections.Generic;

namespace BuildResume.DBContext;

public partial class ProjectLanguage
{
    public int ProjectLanguageId { get; set; }

    public string ProjectLanguageName { get; set; } = null!;

    public bool IsDeleted { get; set; }

    public virtual ICollection<ProjLangDetail> ProjLangDetails { get; set; } = new List<ProjLangDetail>();
}
