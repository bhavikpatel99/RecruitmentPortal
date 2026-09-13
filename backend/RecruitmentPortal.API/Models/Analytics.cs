namespace RecruitmentPortal.API.Models;

public class TimeToFillRow { public int JobId { get; set; } public string Title { get; set; } = string.Empty; public DateTime PostedDate { get; set; } public DateTime FirstHiredAt { get; set; } public int DaysToFill { get; set; } }

public class TimeToHireRow { public int CandidateId { get; set; } public string FirstName { get; set; } = string.Empty; public string LastName { get; set; } = string.Empty; public DateTime AppliedAt { get; set; } public DateTime HiredAt { get; set; } public int DaysToHire { get; set; } }

public class SourceEffectivenessRow { public string Source { get; set; } = string.Empty; public int TotalApplications { get; set; } public int Shortlisted { get; set; } public int Hired { get; set; } }

public class StageFunnelRow { public string Stage { get; set; } = string.Empty; public int CandidateCount { get; set; } }

public class RecruiterProductivityRow
{
    public int UserId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public int RequisitionsCreated { get; set; }
    public int StageMovesMade { get; set; }
    public int InterviewsScheduled { get; set; }
    public int OffersCreated { get; set; }
}

public class InterviewTurnaroundRow { public int InterviewId { get; set; } public DateTime? ScheduledAt { get; set; } public DateTime? LastFeedbackAt { get; set; } public int HoursToFeedback { get; set; } }

public class OfferStatsRow { public string Status { get; set; } = string.Empty; public int Count { get; set; } }
