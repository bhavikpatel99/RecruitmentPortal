using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

/// <summary>
/// Payload used to create or update a job posting. Deliberately excludes
/// Id, PostedBy, PostedDate, CreatedAt and UpdatedAt — those are
/// server-controlled so a client can never spoof who posted a job or
/// forge its audit timestamps (mass-assignment hardening).
/// </summary>
public class JobRequest
{
    [Required, StringLength(200)]
    public string Title { get; set; } = string.Empty;

    [Required]
    public string Description { get; set; } = string.Empty;

    public string? Requirements { get; set; }
    public string? Responsibilities { get; set; }

    [Required, StringLength(200)]
    public string Location { get; set; } = string.Empty;

    [StringLength(50)]
    public string? EmploymentType { get; set; }

    public decimal? SalaryMin { get; set; }
    public decimal? SalaryMax { get; set; }
    public int? ExperienceYearsMin { get; set; }
    public int? ExperienceYearsMax { get; set; }
    public string? Skills { get; set; }

    [Required, StringLength(150)]
    public string Department { get; set; } = string.Empty;

    /// <summary>Optional on create (server defaults to "Open"); used on update for actions like closing a job.</summary>
    [StringLength(30)]
    public string? Status { get; set; }

    public DateTime? ClosedDate { get; set; }

    // Job Description Builder (spec module 5)
    public string? MustHaveSkills { get; set; }
    public string? NiceToHaveSkills { get; set; }
    public string? EducationRequirement { get; set; }
    public string? WorkMode { get; set; }
    public string? BenefitsText { get; set; }
    public string? LegalText { get; set; }
    public int? JobRequisitionId { get; set; }
}
