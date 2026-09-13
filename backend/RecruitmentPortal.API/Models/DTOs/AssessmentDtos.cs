using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

public class AssessmentTemplateRequest
{
    [Required, StringLength(256)]
    public string Title { get; set; } = string.Empty;

    [Required, StringLength(50)]
    public string AssessmentType { get; set; } = "Technical";

    [StringLength(1000)]
    public string? Description { get; set; }

    [StringLength(150)]
    public string? VendorName { get; set; }

    [StringLength(500)]
    public string? ExternalLink { get; set; }

    public int? PassingScore { get; set; }

    public int? DurationMinutes { get; set; }
}

public class AssessmentInvitationRequest
{
    [Required]
    public int CandidateId { get; set; }

    [Required]
    public int AssessmentTemplateId { get; set; }

    public DateTime? Deadline { get; set; }
}

public class AssessmentResultRequest
{
    [Required]
    public int Score { get; set; }

    [StringLength(1000)]
    public string? Notes { get; set; }
}

public class AssessmentStatusRequest
{
    [Required, StringLength(30)]
    public string Status { get; set; } = string.Empty;
}
