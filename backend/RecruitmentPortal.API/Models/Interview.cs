namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.Interviews (spec module 14).</summary>
public class Interview
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public int? JobId { get; set; }
    public int RoundNumber { get; set; } = 1;
    public string? InterviewType { get; set; }
    public DateTime? ScheduledAt { get; set; }
    public int? DurationMinutes { get; set; }
    public string? Mode { get; set; }
    public string? MeetingLink { get; set; }
    public string? Location { get; set; }
    public string Status { get; set; } = "Scheduled";
    public string? CancellationReason { get; set; }
    public int? ScheduledBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

/// <summary>Maps to dbo.InterviewPanelists.</summary>
public class InterviewPanelist
{
    public int Id { get; set; }
    public int InterviewId { get; set; }
    public int InterviewerId { get; set; }
    public bool IsLead { get; set; }
    public string? InterviewerName { get; set; }
    public string? InterviewerEmail { get; set; }
}

/// <summary>Maps to dbo.InterviewFeedback - a structured interview scorecard.</summary>
public class InterviewFeedback
{
    public int Id { get; set; }
    public int InterviewId { get; set; }
    public int InterviewerId { get; set; }
    public string? InterviewerName { get; set; }
    public int? Rating { get; set; }
    public string? Recommendation { get; set; }
    public string? Strengths { get; set; }
    public string? Concerns { get; set; }
    public string? Comments { get; set; }
    public DateTime? SubmittedAt { get; set; }
    public DateTime CreatedAt { get; set; }
}
