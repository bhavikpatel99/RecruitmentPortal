using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

/// <summary>Payload used to create or update a job requisition (manpower request).</summary>
public class JobRequisitionRequest
{
    [Required, StringLength(256)]
    public string Title { get; set; } = string.Empty;

    [Required, StringLength(256)]
    public string Department { get; set; } = string.Empty;

    [Required, StringLength(256)]
    public string Location { get; set; } = string.Empty;

    [StringLength(100)]
    public string? EmploymentType { get; set; }

    [Range(1, 1000)]
    public int Vacancies { get; set; } = 1;

    [Required, StringLength(50)]
    public string Priority { get; set; } = "Medium";

    [Required, StringLength(50)]
    public string RequisitionType { get; set; } = "New";

    public DateTime? TargetJoiningDate { get; set; }

    [StringLength(200)]
    public string? BudgetReference { get; set; }

    public string? JustificationNotes { get; set; }

    public string? RequiredSkills { get; set; }

    public int? HiringManagerId { get; set; }

    public int? RecruiterId { get; set; }

    public int? JobId { get; set; }
}

/// <summary>Payload for approve/reject/hold/reopen/close status transitions.</summary>
public class JobRequisitionStatusRequest
{
    [Required, StringLength(50)]
    public string NewStatus { get; set; } = string.Empty;

    [StringLength(500)]
    public string? RejectionReason { get; set; }

    [StringLength(500)]
    public string? Notes { get; set; }
}
