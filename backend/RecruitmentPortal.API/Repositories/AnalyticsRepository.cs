using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based read-only aggregate reporting (spec module 25).</summary>
public sealed class AnalyticsRepository : IAnalyticsRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public AnalyticsRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    private IDbConnection Conn() => _connectionFactory.CreateConnection();

    public async Task<IEnumerable<TimeToFillRow>> GetTimeToFillAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<TimeToFillRow>("sp_Analytics_TimeToFill", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<TimeToHireRow>> GetTimeToHireAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<TimeToHireRow>("sp_Analytics_TimeToHire", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<SourceEffectivenessRow>> GetSourceEffectivenessAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<SourceEffectivenessRow>("sp_Analytics_SourceEffectiveness", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<StageFunnelRow>> GetStageFunnelAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<StageFunnelRow>("sp_Analytics_StageFunnel", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<RecruiterProductivityRow>> GetRecruiterProductivityAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<RecruiterProductivityRow>("sp_Analytics_RecruiterProductivity", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<InterviewTurnaroundRow>> GetInterviewTurnaroundAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<InterviewTurnaroundRow>("sp_Analytics_InterviewTurnaround", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<OfferStatsRow>> GetOfferStatsAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<OfferStatsRow>("sp_Analytics_OfferStats", commandType: CommandType.StoredProcedure);
    }
}
