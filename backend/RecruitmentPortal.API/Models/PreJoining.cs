namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.PreJoiningChecklists (spec module 17).</summary>
public class PreJoiningChecklist
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public int OfferId { get; set; }
    public DateTime? JoiningDate { get; set; }
    public string BgvStatus { get; set; } = "NotStarted";
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

/// <summary>Maps to dbo.PreJoiningTasks.</summary>
public class PreJoiningTask
{
    public int Id { get; set; }
    public int ChecklistId { get; set; }
    public string TaskName { get; set; } = string.Empty;
    public bool IsCompleted { get; set; }
    public DateTime? CompletedAt { get; set; }
    public string? Notes { get; set; }
    public int SortOrder { get; set; }
}

/// <summary>Maps to dbo.HireEvents - the structured handoff to HR/ERP (spec workflow step 9).</summary>
public class HireEvent
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public int OfferId { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string Payload { get; set; } = string.Empty;
    public string Status { get; set; } = "Pending";
    public DateTime CreatedAt { get; set; }
    public DateTime? SentAt { get; set; }
}
