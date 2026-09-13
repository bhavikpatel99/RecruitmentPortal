namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.AssessmentTemplates (spec module 15).</summary>
public class AssessmentTemplate
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string AssessmentType { get; set; } = "Technical";
    public string? Description { get; set; }
    public string? VendorName { get; set; }
    public string? ExternalLink { get; set; }
    public int? PassingScore { get; set; }
    public int? DurationMinutes { get; set; }
    public bool IsActive { get; set; } = true;
    public int? CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
}

/// <summary>Maps to dbo.AssessmentInvitations.</summary>
public class AssessmentInvitation
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public int AssessmentTemplateId { get; set; }
    public string? AssessmentTitle { get; set; }
    public string? AssessmentType { get; set; }
    public int? InvitedBy { get; set; }
    public DateTime InvitedAt { get; set; }
    public DateTime? Deadline { get; set; }
    public string Status { get; set; } = "Invited";
    public int? Score { get; set; }
    public string? PassFail { get; set; }
    public DateTime? CompletedAt { get; set; }
    public string? Notes { get; set; }
}
