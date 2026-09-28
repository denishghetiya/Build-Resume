using System.Collections.Generic;

namespace BuildResume.ViewModels
{
    public class ResumeDataViewModel
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public long PhoneNumber { get; set; }
        public string Email { get; set; }
        public string? searchTemplate { get; set; }
        public List<ExperienceViewModel> Experience { get; set; } = new List<ExperienceViewModel>();
    }
    public class ExperienceViewModel
    {
        public int ExperienceId { get; set; }
        public string CompanyName { get; set; }
        public DateTime StartDate { get; set; } = DateTime.Today;
        public DateTime EndDate { get; set; } = DateTime.Today;
        public decimal? ExperienceInYear { get; set; }
        public string? Experience { get; set; }
        public string Role { get; set; }
        public List<ProjectViewModel> Projects { get; set; } = new List<ProjectViewModel>();
    }
    public class ProjectViewModel
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string TechnologyNames { get; set; }
        public string Role { get; set; }
        //public string parentPrefix { get; set; }
        public DateTime StartDate { get; set; } = DateTime.Today;
        public DateTime EndDate { get; set; } = DateTime.Today;
        public List<ProjectLanguageViewModel> ProjectLanguage { get; set; } = new List<ProjectLanguageViewModel>();
    }
    public class ProjectLanguageViewModel
    { 
        public int ProjectLanguageId { get; set; }
        public string ProjectLanguageName { get; set; }
        public bool IsChecked { get; set; }
    }
}
