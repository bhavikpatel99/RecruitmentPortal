namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.Jobs.</summary>
public class Job
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string? Requirements { get; set; }
    public string? Responsibilities { get; set; }
    public string Location { get; set; } = string.Empty;
    public string? EmploymentType { get; set; }
    public decimal? SalaryMin { get; set; }
    public decimal? SalaryMax { get; set; }
    public int? ExperienceYearsMin { get; set; }
    public int? ExperienceYearsMax { get; set; }
    public string? Skills { get; set; }
    public string Department { get; set; } = string.Empty;
    public string Status { get; set; } = "Open";
    public DateTime PostedDate { get; set; }
    public DateTime? ClosedDate { get; set; }
    public int? PostedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }

    // Job Description Builder (spec module 5)
    public string? MustHaveSkills { get; set; }
    public string? NiceToHaveSkills { get; set; }
    public string? EducationRequirement { get; set; }
    public string? WorkMode { get; set; }
    public string? BenefitsText { get; set; }
    public string? LegalText { get; set; }
    public int? JobRequisitionId { get; set; }
}

/// <summary>Maps to dbo.JobPostingChannels (spec module 7: publishing & distribution).</summary>
public class JobPostingChannel
{
    public int Id { get; set; }
    public int JobId { get; set; }
    public string Channel { get; set; } = string.Empty;
    public string Status { get; set; } = "Active";
    public string? ExternalUrl { get; set; }
    public DateTime PostedAt { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public int? CreatedBy { get; set; }
}
