using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for interviews, their panel and scorecards.</summary>
public sealed class InterviewRepository : IInterviewRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public InterviewRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<Interview>> GetAllAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Interview>(
            "sp_Interview_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<Interview>> GetByCandidateIdAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Interview>(
            "sp_Interview_GetByCandidateId",
            new { CandidateId = candidateId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<Interview?> GetByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<Interview>(
            "sp_Interview_GetById",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<Interview>> GetUpcomingAsync(DateTime fromDate)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Interview>(
            "sp_Interview_GetUpcoming",
            new { FromDate = fromDate },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateAsync(Interview interview)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_Interview_Create",
            new
            {
                interview.CandidateId,
                interview.JobId,
                interview.RoundNumber,
                interview.InterviewType,
                interview.ScheduledAt,
                interview.DurationMinutes,
                interview.Mode,
                interview.MeetingLink,
                interview.Location,
                interview.ScheduledBy
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> RescheduleAsync(int id, DateTime scheduledAt, int? durationMinutes, string? mode, string? meetingLink, string? location)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Interview_Reschedule",
            new { Id = id, ScheduledAt = scheduledAt, DurationMinutes = durationMinutes, Mode = mode, MeetingLink = meetingLink, Location = location },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> UpdateStatusAsync(int id, string status, string? cancellationReason)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Interview_UpdateStatus",
            new { Id = id, Status = status, CancellationReason = cancellationReason },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task AddPanelistAsync(int interviewId, int interviewerId, bool isLead)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteScalarAsync<int>(
            "sp_InterviewPanelist_Add",
            new { InterviewId = interviewId, InterviewerId = interviewerId, IsLead = isLead },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> RemovePanelistAsync(int interviewId, int interviewerId)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_InterviewPanelist_Remove",
            new { InterviewId = interviewId, InterviewerId = interviewerId },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<IEnumerable<InterviewPanelist>> GetPanelistsAsync(int interviewId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<InterviewPanelist>(
            "sp_Interview_GetPanelists",
            new { InterviewId = interviewId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task SubmitFeedbackAsync(int interviewId, int interviewerId, int? rating, string? recommendation, string? strengths, string? concerns, string? comments)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteScalarAsync<int>(
            "sp_InterviewFeedback_Submit",
            new
            {
                InterviewId = interviewId,
                InterviewerId = interviewerId,
                Rating = rating,
                Recommendation = recommendation,
                Strengths = strengths,
                Concerns = concerns,
                Comments = comments
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<InterviewFeedback>> GetFeedbackAsync(int interviewId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<InterviewFeedback>(
            "sp_InterviewFeedback_GetByInterviewId",
            new { InterviewId = interviewId },
            commandType: CommandType.StoredProcedure);
    }
}
