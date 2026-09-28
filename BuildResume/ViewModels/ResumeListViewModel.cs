using System.Collections.Generic;

namespace BuildResume.ViewModels
{
    public class ResumeListViewModel
    {
        public int UserId { get; set; }
        public string FullName { get; set; }
        public long PhoneNumber { get; set; }
        public string Email { get; set; }
        public decimal ExperienceInYear { get; set; }
        public string Experience { get; set; }
        public string? searchTemplate { get; set; }
        public List<string> Projects { get; set; }
    }
    public class ProjectList
    {
        public List<string> ProjList { get; set; }
    }
}
