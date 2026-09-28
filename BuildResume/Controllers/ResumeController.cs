using BuildResume.DBContext;
using BuildResume.Services;
using BuildResume.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.AspNetCore.Mvc.ViewFeatures;
using Microsoft.EntityFrameworkCore;

namespace BuildResume.Controllers
{
    public class ResumeController : Controller
    {
        private readonly BuildResumeDBContext _context;
        private readonly IWebHostEnvironment _webHost;
        private readonly EmailService _emailService;
        public ResumeController(BuildResumeDBContext context, IWebHostEnvironment webHost, EmailService emailService)
        {
            _context = context;
            _webHost = webHost;
            _emailService = emailService;
        }
        public async Task<IActionResult> Index()
        {
            return View();
        }
        public async Task<IActionResult> ResumeList()
        {
            var projlist = await _context.Projects
                .Where(p => p.IsDeleted != true)
                .Select(p => p.ProjectName)
                .ToListAsync();

            var model = new ProjectList
            {
                ProjList = projlist
            };

            return View(model);
        }
        [HttpPost]
        public async Task<IActionResult> ResumeList([FromBody] RequestPaginationViewModel model)
        {
            //var search = model.Search?.Trim().ToLower();

            var query = _context.Users
                .Include(p => p.Experiences)
                    .ThenInclude(p => p.Projects)
                .Where(u => u.IsDeleted != true)
                .AsQueryable();

            if (model.Filters != null)
            {
                if (!string.IsNullOrEmpty(model.Filters.field1))
                    query = query.Where(u => u.FirstName != null &&
                                             u.FirstName.ToLower().Contains(model.Filters.field1.ToLower())
                                             || u.LastName.ToLower().Contains(model.Filters.field1.ToLower()));

                if (!string.IsNullOrWhiteSpace(model.Filters.field2))
                {
                    var phoneFilter = model.Filters.field2.Trim();
                    query = query.Where(u => u.PhoneNumber.ToString().StartsWith(phoneFilter));
                }

                if (!string.IsNullOrEmpty(model.Filters.field3))
                    query = query.Where(u => u.Email != null &&
                                             u.Email.ToLower().Contains(model.Filters.field3.ToLower()));

                //if (!string.IsNullOrEmpty(model.Filters.field4))
                //{
                //    query = query.Where(u => u.Experiences
                //        .Where(e => e.IsDeleted != true)
                //        .SelectMany(e => e.Projects.Where(p => p.IsDeleted != true))
                //        .Any(p => p.ProjectName.ToLower() == model.Filters.field4.ToLower())
                //    );
                //}
                if (model.Filters?.field4 != null && model.Filters.field4.Any())
                {
                    var selectedProjects = model.Filters.field4
                        .Where(p => !string.IsNullOrWhiteSpace(p))
                        .Select(p => p.ToLower())
                        .ToList();

                    query = query.Where(u => u.Experiences
                        .Where(e => e.IsDeleted != true)
                        .SelectMany(e => e.Projects.Where(p => p.IsDeleted != true))
                        .Any(p => selectedProjects.Contains(p.ProjectName.ToLower()))
                    );
                }

            }

            //if (!string.IsNullOrEmpty(search))
            //{
            //    query = query.Where(u =>
            //        (u.FirstName != null && u.FirstName.ToLower().Contains(search)) ||
            //        (u.LastName != null && u.LastName.ToLower().Contains(search)) ||
            //        (u.Email != null && u.Email.ToLower().Contains(search)) ||
            //        (u.PhoneNumber.ToString().Contains(search)) ||
            //        (u.Experiences.Where(e => e.IsDeleted != true)
            //                      .SelectMany(e => e.Projects.Where(p => p.IsDeleted != true))
            //                      .Any(p => p.ProjectName.ToLower().Contains(search)))
            //    );
            //}

            var sortColumn = model.Columns?.FirstOrDefault(c => c.Sort != null && c.IsSortable);
            if (sortColumn != null && !string.IsNullOrEmpty(sortColumn.Field))
            {
                var direction = sortColumn.Sort?.Direction ?? KSortDirection.Ascending;

                switch (sortColumn.Field)
                {
                    case "fullName":
                        query = direction == KSortDirection.Ascending
                            ? query.OrderBy(u => u.FirstName)
                            : query.OrderByDescending(u => u.FirstName);
                        break;

                    case "phoneNumber":
                        query = direction == KSortDirection.Ascending
                            ? query.OrderBy(u => u.PhoneNumber)
                            : query.OrderByDescending(u => u.PhoneNumber);
                        break;

                    case "email":
                        query = direction == KSortDirection.Ascending
                            ? query.OrderBy(u => u.Email)
                            : query.OrderByDescending(u => u.Email);
                        break;

                    case "experience":
                        query = direction == KSortDirection.Ascending
                            ? query.OrderBy(u => u.Experiences.Where(r => r.IsDeleted != true).Sum(r => r.ExperienceInYear))
                            : query.OrderByDescending(u => u.Experiences.Where(r => r.IsDeleted != true).Sum(r => r.ExperienceInYear));
                        break;

                    default:
                        query = query.OrderByDescending(u => u.UserId);
                        break;
                }
            }
            else
            {
                query = query.OrderByDescending(u => u.UserId);
            }

            var totalCount = await query.CountAsync();

            var users = query
                .Skip(model.Start)
                .Take(model.Length)
                .AsEnumerable()
                .Select(u =>
                {
                    var totalDays = u.Experiences
                        .Where(e => !e.IsDeleted)
                        .Sum(e => ((e.EndDate - e.StartDate).Days)+1);

                    var date = new DateOnly(1, 1, 1);
                    var newdate = date.AddDays(totalDays);

                    int years = newdate.Year - 1;
                    int months = newdate.Month - 1;
                    int days = newdate.Day - 1;

                    return new ResumeListViewModel
                    {
                        UserId = u.UserId,
                        FullName = u.FirstName + " " + u.LastName,
                        PhoneNumber = u.PhoneNumber,
                        Email = u.Email,
                        searchTemplate = u.Template,
                        Projects = u.Experiences
                                    .Where(e => !e.IsDeleted)
                                    .SelectMany(e => e.Projects.Where(p => !p.IsDeleted))
                                    .Select(p => p.ProjectName)
                                    .ToList(),
                        Experience = $"{years}Y {months}M {days}D"
                    };
                }).ToList();

            return Json(new
            {
                draw = model.Draw,
                recordsTotal = totalCount,
                recordsFiltered = totalCount,
                data = users
            });
        }
        public async Task<IActionResult> CreateResume(int? userId)
        {
            if (userId == 0 || userId == null)
            {
                var model = new ResumeDataViewModel
                {
                    Experience = new List<ExperienceViewModel>(){ new ExperienceViewModel
                {
                    Projects = new List<ProjectViewModel>(){ new ProjectViewModel
                    {
                        ProjectLanguage =  _context.ProjectLanguages
                            .Where(d => d.IsDeleted != true)
                            .Select(d => new ProjectLanguageViewModel
                            {
                                ProjectLanguageId = d.ProjectLanguageId,
                                ProjectLanguageName = d.ProjectLanguageName
                            }).ToList()
                    } }.ToList()
                } }.ToList()
                };
                return View(model);
            }
            if (userId != 0 || userId != null)
            {
                var user = await _context.Users.Include(a => a.Experiences.Where(e => e.IsDeleted != true))
                .ThenInclude(p => p.Projects.Where(e => e.IsDeleted != true))
                .ThenInclude(pl => pl.ProjLangDetails.Where(e => e.IsDeleted != true))
                .FirstOrDefaultAsync(a => a.UserId == userId && a.IsDeleted != true);

                var projlang = await _context.ProjectLanguages.Where(pl => pl.IsDeleted != true).ToListAsync();

                var model = new ResumeDataViewModel
                {
                    UserId = user.UserId,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    PhoneNumber = user.PhoneNumber,
                    Email = user.Email,
                    searchTemplate = user.Template,
                    Experience = user.Experiences.Where(u => u.IsDeleted != true).Select(u => new ExperienceViewModel
                    {
                        ExperienceId = u.ExperienceId,
                        CompanyName = u.CompanyName,
                        StartDate = u.StartDate,
                        EndDate = u.EndDate,
                        //ExperienceInYear = u.ExperienceInYear,
                        //ExperienceInYear = Math.Round((decimal)(u.EndDate.Date - u.StartDate.Date).TotalDays / 365, 2),
                        ExperienceInYear = expyear(u.StartDate, u.EndDate),
                        Role = u.Role,
                        Projects = u.Projects.Where(p => p.IsDeleted != true).Select(p => new ProjectViewModel
                        {
                            ProjectId = p.ProjectId,
                            ProjectName = p.ProjectName,
                            TechnologyNames = p.TechnologyNames,
                            Role = p.Role,
                            StartDate = p.StartDate,
                            EndDate = p.EndDate,
                            ProjectLanguage = projlang.Select(prjl => new ProjectLanguageViewModel
                            {
                                ProjectLanguageId = prjl.ProjectLanguageId,
                                ProjectLanguageName = prjl.ProjectLanguageName,
                                IsChecked = p.ProjLangDetails.Any(pli => pli.ProjectLanguageId == prjl.ProjectLanguageId && pli.IsDeleted != true)
                            }).ToList()
                        }).ToList()
                    }).ToList()
                };
                return View(model);
            }
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> CreateResume(ResumeDataViewModel model)
        {
            if (model.Experience.Count == 0)
            {
                return Json(new { success = false, message = "Experience should be 1 or more." });
            }
            if (model.Experience.Any(exp => exp.Projects == null || !exp.Projects.Any()))
            {
                return Json(new { success = false, message = "Each experience must have 1 or more project." });
            }
            if (model.UserId == 0 || model.UserId == null)
            {
                var user = new User
                {
                    FirstName = model.FirstName,
                    LastName = model.LastName,
                    PhoneNumber = model.PhoneNumber,
                    Email = model.Email,
                    Template = model.searchTemplate,
                    Experiences = model.Experience
                    .Where(exp => exp != null)
                    .Select(exp => new Experience
                    {
                        CompanyName = exp.CompanyName,
                        StartDate = exp.StartDate,
                        EndDate = exp.EndDate,
                        Role = exp.Role,
                        //ExperienceInYear = Math.Round((decimal)(exp.EndDate.Date - exp.StartDate.Date).TotalDays / 365, 2),
                        ExperienceInYear = expyear(exp.StartDate, exp.EndDate),
                        Projects = exp.Projects
                        .Where(proj => proj != null)
                        .Select(proj => new Project
                        {
                            ProjectName = proj.ProjectName,
                            Role = proj.Role,
                            TechnologyNames = proj.TechnologyNames,
                            StartDate = proj.StartDate,
                            EndDate = proj.EndDate,
                            ProjLangDetails = proj.ProjectLanguage.Where(lang => lang.IsChecked == true).Select(lang => new ProjLangDetail
                            {
                                ProjectLanguageId = lang.ProjectLanguageId
                            }).ToList()
                        }).ToList()
                    }).ToList()
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Resume created successfully" });
            }
            if (model.UserId != 0 || model.UserId != null)
            {
                var user = await _context.Users.Include(a => a.Experiences.Where(e => e.IsDeleted != true))
                .ThenInclude(p => p.Projects.Where(e => e.IsDeleted != true))
                .ThenInclude(pl => pl.ProjLangDetails.Where(e => e.IsDeleted != true))
                .FirstOrDefaultAsync(a => a.UserId == model.UserId && a.IsDeleted != true);

                user.FirstName = model.FirstName;
                user.LastName = model.LastName;
                user.PhoneNumber = model.PhoneNumber;
                user.Email = model.Email;
                user.Template = model.searchTemplate;
                //var deleteexp = user.Experiences.Where(d => !model.Experience.Any(nd => nd != null && nd.ExperienceId == d.ExperienceId)).ToList();
                //if (deleteexp.Any())
                //{
                //    foreach (var item in deleteexp)
                //    {
                //        foreach (var item1 in item.Projects)
                //        {
                //            var pl = item1.ProjLangDetails.Where(pl => pl.IsDeleted != true).ToList();
                //            pl.ForEach(lp => lp.IsDeleted = true);
                //        }
                //        var pr = item.Projects.Where(lp => lp.IsDeleted = true).ToList();
                //        pr.ForEach(rp => rp.IsDeleted = true);
                //    }
                //    deleteexp.ForEach(p => p.IsDeleted = true);
                //}

                user.Experiences
                    .Where(d => !model.Experience.Any(nd => nd != null && nd.ExperienceId == d.ExperienceId))
                    .ToList().ForEach(expp =>
                    {
                        expp.Projects.Where(pr => pr.IsDeleted != true).ToList().ForEach(pr =>
                            {
                                pr.ProjLangDetails.Where(pll => !pll.IsDeleted)
                                    .ToList().ForEach(pll => pll.IsDeleted = true);
                                pr.IsDeleted = true;
                            });
                        expp.IsDeleted = true;
                    });

                foreach (var i in model.Experience.Where(exp => exp != null))
                {
                    var experience = user.Experiences.FirstOrDefault(e => e.ExperienceId == i.ExperienceId && e.IsDeleted != true);

                    if (experience == null)
                    {
                        user.Experiences.Add(new Experience
                        {
                            UserId = user.UserId,
                            CompanyName = i.CompanyName,
                            StartDate = i.StartDate,
                            EndDate = i.EndDate,
                            Role = i.Role,
                            //ExperienceInYear = Math.Round((decimal)(i.EndDate.Date - i.StartDate.Date).TotalDays / 365, 2),
                            ExperienceInYear = expyear(i.StartDate, i.EndDate),
                            Projects = i.Projects
                            .Where(proj => proj != null)
                            .Select(proj => new Project
                            {
                                ProjectName = proj.ProjectName,
                                Role = proj.Role,
                                TechnologyNames = proj.TechnologyNames,
                                StartDate = proj.StartDate,
                                EndDate = proj.EndDate,
                                ProjLangDetails = proj.ProjectLanguage.Where(lang => lang.IsChecked == true).Select(lang => new ProjLangDetail
                                {
                                    ProjectLanguageId = lang.ProjectLanguageId
                                }).ToList()
                            }).ToList()
                        });
                    }
                    if (experience != null)
                    {
                        experience.CompanyName = i.CompanyName;
                        experience.StartDate = i.StartDate;
                        experience.EndDate = i.EndDate;
                        experience.Role = i.Role;
                        //experience.ExperienceInYear = Math.Round((decimal)(i.EndDate.Date - i.StartDate.Date).TotalDays / 365, 2);
                        experience.ExperienceInYear = expyear(i.StartDate, i.EndDate);

                        //var deleteproj = experience.Projects.Where(d => !i.Projects.Any(nd => nd.ProjectId == d.ProjectId)).ToList();
                        //if (deleteproj.Any())
                        //{
                        //    foreach (var item1 in deleteproj)
                        //    {
                        //        var pl = item1.ProjLangDetails.Where(pl => pl.IsDeleted != true).ToList();
                        //        pl.ForEach(lp => lp.IsDeleted = true);
                        //    }
                        //    deleteproj.ForEach(p => p.IsDeleted = true);
                        //}
                        experience.Projects
                            .Where(d => !i.Projects.Any(nd => nd.ProjectId == d.ProjectId)).ToList()
                            .ForEach(project =>
                            {
                                project.ProjLangDetails.Where(pl => !pl.IsDeleted)
                                    .ToList().ForEach(pl => pl.IsDeleted = true);
                                project.IsDeleted = true;
                            });

                        foreach (var j in i.Projects.Where(exp => exp != null))
                        {
                            var project = experience.Projects.FirstOrDefault(p => p.ProjectId == j.ProjectId && p.IsDeleted != true);
                            if (project == null || j.ProjectId == 0)
                            {
                                experience.Projects.Add(new Project
                                {
                                    ProjectName = j.ProjectName,
                                    Role = j.Role,
                                    TechnologyNames = j.TechnologyNames,
                                    StartDate = j.StartDate,
                                    EndDate = j.EndDate,
                                    ProjLangDetails = j.ProjectLanguage.Where(lang => lang.IsChecked == true).Select(lang => new ProjLangDetail
                                    {
                                        ProjectLanguageId = lang.ProjectLanguageId
                                    }).ToList()
                                });
                            }
                            if (project != null && j.ProjectId != 0)
                            {
                                project.ProjectName = j.ProjectName;
                                project.Role = j.Role;
                                project.TechnologyNames = j.TechnologyNames;
                                project.StartDate = j.StartDate;
                                project.EndDate = j.EndDate;

                                foreach (var k in j.ProjectLanguage)
                                {
                                    if (k.IsChecked == true)
                                    {
                                        if (project != null)
                                        {
                                            var projlang = project.ProjLangDetails.Any(q => q.ProjectId == j.ProjectId && q.ProjectLanguageId == k.ProjectLanguageId && q.IsDeleted != true);
                                            if (projlang != true)
                                            {
                                                project.ProjLangDetails.Add(new ProjLangDetail
                                                {
                                                    ProjectLanguageId = k.ProjectLanguageId
                                                });
                                            }
                                        }
                                    }
                                    if (k.IsChecked == false)
                                    {
                                        if (project != null)
                                        {
                                            var projlang = project.ProjLangDetails.FirstOrDefault(q => q.ProjectId == j.ProjectId && q.ProjectLanguageId == k.ProjectLanguageId && q.IsDeleted != true);
                                            if (projlang != null)
                                            {
                                                if (projlang.IsDeleted != true)
                                                {
                                                    projlang.IsDeleted = true;
                                                    _context.ProjLangDetails.Update(projlang);
                                                }
                                            }
                                        }
                                    }
                                }
                                ;
                            }
                        }
                        ;
                    }
                }
                ;
                _context.Users.Update(user);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Resume edited successfully" });
            }
            return View(model);
        }
        
        public async Task<IActionResult> DeleteResume(int? userId)
        {
            var user = await _context.Users.Include(a => a.Experiences.Where(e => e.IsDeleted != true))
                .ThenInclude(p => p.Projects.Where(e => e.IsDeleted != true))
                .ThenInclude(pl => pl.ProjLangDetails.Where(e => e.IsDeleted != true))
                .FirstOrDefaultAsync(a => a.UserId == userId && a.IsDeleted != true);

            user.IsDeleted = true;

            //foreach (var i in user.Experiences)
            //{
            //    var experience = await _context.Experiences.FirstOrDefaultAsync(e => e.ExperienceId == i.ExperienceId && e.IsDeleted != true);
            //    experience.IsDeleted = true;
            //
            //    foreach (var j in experience.Projects)
            //    {
            //        var project = await _context.Projects.FirstOrDefaultAsync(p => p.ProjectId == j.ProjectId && p.IsDeleted != true);
            //        project.IsDeleted = true;
            //
            //        foreach (var k in project.ProjLangDetails)
            //        {
            //            var projlang = await _context.ProjLangDetails.FirstOrDefaultAsync(q => q.ProjectId == j.ProjectId && q.ProjectLanguageId == k.ProjectLanguageId && q.IsDeleted != true);
            //            projlang.IsDeleted = true;
            //            _context.ProjLangDetails.Update(projlang);
            //        }
            //        ;
            //        _context.Projects.Update(project);
            //    }
            //    ;
            //    _context.Experiences.Update(experience);
            //}
            //;

            user.Experiences
                .Where(d => d.IsDeleted != true)
                .ToList().ForEach(exp =>
                {
                    exp.Projects.Where(p => p.IsDeleted != true).ToList().ForEach(p =>
                    {
                        p.ProjLangDetails.Where(pl => pl.IsDeleted != true)
                            .ToList().ForEach(pl => pl.IsDeleted = true);
                        p.IsDeleted = true;
                    });
                    exp.IsDeleted = true;
                });

            _context.Users.Update(user);

            await _context.SaveChangesAsync();
            return Redirect("ResumeList");
        }
        public async Task<IActionResult> GetEmptyPartial()
        {
            var model = new ExperienceViewModel
            {
                Projects = new List<ProjectViewModel>(){ new ProjectViewModel
                {
                    ProjectLanguage =  _context.ProjectLanguages
                        .Where(d => d.IsDeleted != true)
                        .Select(d => new ProjectLanguageViewModel
                        {
                            ProjectLanguageId = d.ProjectLanguageId,
                            ProjectLanguageName = d.ProjectLanguageName
                        }).ToList()
                }}.ToList()
            };
            return PartialView("_Experience", model);
        }
        public async Task<IActionResult> GetEmptyPartialProject(string parentPrefix)
        {
            var project = new ProjectViewModel() ;
            //var project = new ProjectViewModel() { parentPrefix = parentPrefix };

            project.ProjectLanguage = _context.ProjectLanguages
                .Where(d => d.IsDeleted != true)
                .Select(d => new ProjectLanguageViewModel
                {
                    ProjectLanguageId = d.ProjectLanguageId,
                    ProjectLanguageName = d.ProjectLanguageName
                }).ToList();

            var viewData = new ViewDataDictionary<ProjectViewModel>(
                                metadataProvider: new EmptyModelMetadataProvider(),
                                modelState: ModelState)
            { Model = project };

            viewData["ParentPrefix"] = parentPrefix;
            //return PartialView("_Projects", project);
            return new PartialViewResult
            {
                ViewName = "_Projects",
                ViewData = viewData
            };
        }
        [HttpPost]
        public async Task<IActionResult> GetTemplate(string template, ResumeDataViewModel model)
        {
            var data = new ResumeDataViewModel
            {
                UserId = model.UserId,
                FirstName = model.FirstName,
                LastName = model.LastName,
                PhoneNumber = model.PhoneNumber,
                Email = model.Email,
                searchTemplate = model.searchTemplate,
                Experience = model.Experience.Select(u => new ExperienceViewModel
                {
                    ExperienceId = u.ExperienceId,
                    CompanyName = u.CompanyName,
                    StartDate = u.StartDate,
                    EndDate = u.EndDate,
                    Experience = u.Experience,
                    Role = u.Role,
                    Projects = u.Projects.Select(p => new ProjectViewModel
                    {
                        ProjectId = p.ProjectId,
                        ProjectName = p.ProjectName,
                        TechnologyNames = p.TechnologyNames,
                        Role = p.Role,
                        StartDate = p.StartDate,
                        EndDate = p.EndDate,
                        ProjectLanguage = p.ProjectLanguage.Select(prjl => new ProjectLanguageViewModel
                        {
                            ProjectLanguageId = prjl.ProjectLanguageId,
                            ProjectLanguageName = prjl.ProjectLanguageName,
                            IsChecked = prjl.IsChecked
                        }).ToList()
                    }).ToList()
                }).ToList()
            };
            return PartialView(template,data);
        }
        
        [HttpPost]
        public async Task<IActionResult> SendMail(string data,string email)
        {
            var subject = "Your Resume";
            await _emailService.SendEmailAsync(email, subject, data);
            return Json(new { success = true, message = "Resume send successfully" });
        }
        public async Task<IActionResult> GetData(int userId)
        {
            var user = await _context.Users.Include(a => a.Experiences.Where(e => e.IsDeleted != true))
                .ThenInclude(p => p.Projects.Where(e => e.IsDeleted != true))
                .ThenInclude(pl => pl.ProjLangDetails.Where(e => e.IsDeleted != true))
                .FirstOrDefaultAsync(a => a.UserId == userId && a.IsDeleted != true);

            var projlang = await _context.ProjectLanguages.Where(pl => pl.IsDeleted != true).ToListAsync();

            var model = new ResumeDataViewModel
            {
                UserId = user.UserId,
                FirstName = user.FirstName,
                LastName = user.LastName,
                PhoneNumber = user.PhoneNumber,
                Email = user.Email,
                searchTemplate = user.Template,
                Experience = user.Experiences.Where(u => u.IsDeleted != true).Select(u => new ExperienceViewModel
                {
                    ExperienceId = u.ExperienceId,
                    CompanyName = u.CompanyName,
                    StartDate = u.StartDate,
                    EndDate = u.EndDate,
                    ExperienceInYear = expyear(u.StartDate, u.EndDate),
                    Experience = experience(u.StartDate,u.EndDate),
                    Role = u.Role,
                    Projects = u.Projects.Where(p => p.IsDeleted != true).Select(p => new ProjectViewModel
                    {
                        ProjectId = p.ProjectId,
                        ProjectName = p.ProjectName,
                        TechnologyNames = p.TechnologyNames,
                        Role = p.Role,
                        StartDate = p.StartDate,
                        EndDate = p.EndDate,
                        ProjectLanguage = projlang.Select(prjl => new ProjectLanguageViewModel
                        {
                            ProjectLanguageId = prjl.ProjectLanguageId,
                            ProjectLanguageName = prjl.ProjectLanguageName,
                            IsChecked = p.ProjLangDetails.Any(pli => pli.ProjectLanguageId == prjl.ProjectLanguageId && pli.IsDeleted != true)
                        }).ToList()
                    }).ToList()
                }).ToList()
            };
            return Json(new { success = true, message = "get data successfully", data=model, template=model.searchTemplate, email=model.Email});
        }
        

        public decimal expyear(DateTime StartDate, DateTime EndDate)
        {
            var startDate = StartDate.Date;
            var endDate = EndDate.Date;
            double totalDays = (endDate - startDate).TotalDays;

            int startYear = startDate.Year;
            int endYear = endDate.Year;

            int leapYearCount = 0;
            for (int year = startYear; year <= endYear; year++)
            {
                if (DateTime.IsLeapYear(year))
                    leapYearCount++;
            }

            int totalYears = endYear - startYear + 1;
            int normalYearCount = totalYears - leapYearCount;

            int totalYearDays = (leapYearCount * 366) + (normalYearCount * 365);

            var expyear = Math.Round((decimal)totalDays / totalYearDays * totalYears, 2);
            return expyear;
        }

        public string experience(DateTime StartDate, DateTime EndDate)
        {
            var totalDays = ((EndDate - StartDate).Days) + 1;

            var date = new DateOnly(1, 1, 1);
            var newdate = date.AddDays(totalDays);

            int years = newdate.Year - 1;
            int months = newdate.Month - 1;
            int days = newdate.Day - 1;

            var exp = $"{years}Y {months}M {days}D";

            return exp;
        }
    }
}
