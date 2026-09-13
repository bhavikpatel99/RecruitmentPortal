using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

/// <summary>Payload used to schedule a new interview.</summary>
public class ScheduleInterviewRequest
{
    [Required]
    public int CandidateId { get; set; }

    public int? JobId { get; set; }

    [Range(1, 20)]
    public int RoundNumber { get; set; } = 1;

    [StringLength(100)]
    public string? InterviewType { get; set; }

    public DateTime? ScheduledAt { get; set; }

    [Range(5, 480)]
    public int? DurationMinutes { get; set; }

    [StringLength(50)]
    public string? Mode { get; set; }

    [StringLength(500)]
    public string? MeetingLink { get; set; }

    [StringLength(300)]
    public string? Location { get; set; }

    /// <summary>User ids of the panel members to invite.</summary>
    public List<int> PanelistIds { get; set; } = new();

    public int? LeadInterviewerId { get; set; }
}

/// <summary>Payload used to reschedule an existing interview.</summary>
public class RescheduleInterviewRequest
{
    [Required]
    public DateTime ScheduledAt { get; set; }

    [Range(5, 480)]
    public int? DurationMinutes { get; set; }

    [StringLength(50)]
    public string? Mode { get; set; }

    [StringLength(500)]
    public string? MeetingLink { get; set; }

    [StringLength(300)]
    public string? Location { get; set; }
}

/// <summary>Payload used to cancel/complete/mark-no-show an interview.</summary>
public class InterviewStatusRequest
{
    [Required, StringLength(50)]
    public string Status { get; set; } = string.Empty;

    [StringLength(500)]
    public string? CancellationReason { get; set; }
}

/// <summary>Payload used by an interviewer to submit a structured scorecard.</summary>
public class InterviewFeedbackRequest
{
    [Range(1, 5)]
    public int? Rating { get; set; }

    [StringLength(50)]
    public string? Recommendation { get; set; }

    public string? Strengths { get; set; }

    public string? Concerns { get; set; }

    public string? Comments { get; set; }
}
