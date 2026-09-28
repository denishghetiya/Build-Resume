using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace BuildResume.DBContext;

public partial class BuildResumeDBContext : DbContext
{
    public BuildResumeDBContext(DbContextOptions<BuildResumeDBContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Experience> Experiences { get; set; }

    public virtual DbSet<ProjLangDetail> ProjLangDetails { get; set; }

    public virtual DbSet<Project> Projects { get; set; }

    public virtual DbSet<ProjectLanguage> ProjectLanguages { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Experience>(entity =>
        {
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.ExperienceInYear).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.StartDate).HasColumnType("datetime");

            entity.HasOne(d => d.User).WithMany(p => p.Experiences)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_Experience_UserId_Users_UserId");
        });

        modelBuilder.Entity<ProjLangDetail>(entity =>
        {
            entity.HasOne(d => d.Project).WithMany(p => p.ProjLangDetails)
                .HasForeignKey(d => d.ProjectId)
                .HasConstraintName("fk_ProjLangDetails_ProjectId_Projects_ProjectId");

            entity.HasOne(d => d.ProjectLanguage).WithMany(p => p.ProjLangDetails)
                .HasForeignKey(d => d.ProjectLanguageId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_ProjLangDetails_ProjectLanguageId_ProjectLanguages_ProjectLanguageId");

            entity.HasOne(d => d.User).WithMany(p => p.ProjLangDetails)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("fk_ProjLangDetails_UserId_Users_UserId");
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");

            entity.HasOne(d => d.Experience).WithMany(p => p.Projects)
                .HasForeignKey(d => d.ExperienceId)
                .HasConstraintName("fk_Projects_ExperienceId_Experiences_ExperienceId");

            entity.HasOne(d => d.User).WithMany(p => p.Projects)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("fk_Projects_UserId_Users_UserId");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
