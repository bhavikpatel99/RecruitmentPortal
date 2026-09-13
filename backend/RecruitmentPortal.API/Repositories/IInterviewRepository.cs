using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface IInterviewRepository
{
    Task<IEnumerable<Interview>> GetAllAsync();
    Task<IEnumerable<Interview>> GetByCandidateIdAsync(int candidateId);
    Task<Interview?> GetByIdAsync(int id);
    Task<IEnumerable<Interview>> GetUpcomingAsync(DateTime fromDate);
    Task<int> CreateAsync(Interview interview);
    Task<bool> RescheduleAsync(int id, DateTime scheduledAt, int? durationMinutes, string? mode, string? meetingLink, string? location);
    Task<bool> UpdateStatusAsync(int id, string status, string? cancellationReason);

    Task AddPanelistAsync(int interviewId, int interviewerId, bool isLead);
    Task<bool> RemovePanelistAsync(int interviewId, int interviewerId);
    Task<IEnumerable<InterviewPanelist>> GetPanelistsAsync(int interviewId);

    Task SubmitFeedbackAsync(int interviewId, int interviewerId, int? rating, string? recommendation, string? strengths, string? concerns, string? comments);
    Task<IEnumerable<InterviewFeedback>> GetFeedbackAsync(int interviewId);
}
