namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.CandidateStageHistory - an audit trail of pipeline stage changes.</summary>
public class CandidateStageHistory
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public string? FromStatus { get; set; }
    public string ToStatus { get; set; } = string.Empty;
    public int? ChangedBy { get; set; }
    public string? Reason { get; set; }
    public string? Notes { get; set; }
    public DateTime ChangedAt { get; set; }
}
