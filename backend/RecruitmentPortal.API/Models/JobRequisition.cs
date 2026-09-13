namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.JobRequisitions - manpower request through approval workflow (spec modules 3 & 4).</summary>
public class JobRequisition
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Department { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string? EmploymentType { get; set; }
    public int Vacancies { get; set; } = 1;
    public string Priority { get; set; } = "Medium";
    public string RequisitionType { get; set; } = "New";
    public DateTime? TargetJoiningDate { get; set; }
    public string? BudgetReference { get; set; }
    public string? JustificationNotes { get; set; }
    public string? RequiredSkills { get; set; }
    public int? HiringManagerId { get; set; }
    public int? RecruiterId { get; set; }
    public int? JobId { get; set; }
    public string Status { get; set; } = "Draft";
    public int? ApprovedBy { get; set; }
    public DateTime? ApprovedAt { get; set; }
    public string? RejectionReason { get; set; }
    public int? CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

/// <summary>Maps to dbo.JobRequisitionAudit.</summary>
public class JobRequisitionAudit
{
    public int Id { get; set; }
    public int JobRequisitionId { get; set; }
    public string Action { get; set; } = string.Empty;
    public string? FromStatus { get; set; }
    public string? ToStatus { get; set; }
    public int? PerformedBy { get; set; }
    public string? Notes { get; set; }
    public DateTime PerformedAt { get; set; }
}
