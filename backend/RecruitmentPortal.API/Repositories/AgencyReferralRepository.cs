using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for the Agency/Vendor Portal and Employee Referral Portal.</summary>
public sealed class AgencyReferralRepository : IAgencyReferralRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public AgencyReferralRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    private IDbConnection Conn() => _connectionFactory.CreateConnection();

    public async Task<int> CreateAgencyAsync(string name, string? contactEmail, string? contactPhone)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_Agency_Create", new { Name = name, ContactEmail = contactEmail, ContactPhone = contactPhone }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<Agency>> GetAgenciesAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<Agency>("sp_Agency_GetAll", commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateAgencyUserAsync(int agencyId, string fullName, string email, string passwordHash)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_Agency_CreateUser",
            new { AgencyId = agencyId, FullName = fullName, Email = email, PasswordHash = passwordHash },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AgencyPerformance>> GetAgencyPerformanceAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<AgencyPerformance>("sp_Agency_GetPerformance", commandType: CommandType.StoredProcedure);
    }

    public async Task<AgencyDuplicateCheck?> CheckDuplicateAsync(string email)
    {
        using var c = Conn();
        return await c.QuerySingleOrDefaultAsync<AgencyDuplicateCheck>("sp_AgencySubmission_CheckDuplicate", new { Email = email }, commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateAgencySubmissionAsync(int agencyId, int? jobId, int? candidateId, int submittedBy, bool wasDuplicate, int? duplicateOfCandidateId)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_AgencySubmission_Create",
            new { AgencyId = agencyId, JobId = jobId, CandidateId = candidateId, SubmittedBy = submittedBy, WasDuplicate = wasDuplicate, DuplicateOfCandidateId = duplicateOfCandidateId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AgencySubmission>> GetSubmissionsByAgencyIdAsync(int agencyId)
    {
        using var c = Conn();
        return await c.QueryAsync<AgencySubmission>("sp_AgencySubmission_GetByAgencyId", new { AgencyId = agencyId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AgencySubmission>> GetAllSubmissionsAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<AgencySubmission>("sp_AgencySubmission_GetAll", commandType: CommandType.StoredProcedure);
    }

    public async Task<(int Id, string ReferralCode)> CreateReferralLinkAsync(int referrerUserId, int jobId)
    {
        using var c = Conn();
        var result = await c.QuerySingleAsync("sp_Referral_CreateLink", new { ReferrerUserId = referrerUserId, JobId = jobId }, commandType: CommandType.StoredProcedure);
        return ((int)result.Id, (string)result.ReferralCode);
    }

    public async Task<Referral?> GetReferralByCodeAsync(string referralCode)
    {
        using var c = Conn();
        return await c.QuerySingleOrDefaultAsync<Referral>("sp_Referral_GetByCode", new { ReferralCode = referralCode }, commandType: CommandType.StoredProcedure);
    }

    public async Task<Referral?> GetReferralByCandidateIdAsync(int candidateId)
    {
        using var c = Conn();
        return await c.QuerySingleOrDefaultAsync<Referral>("sp_Referral_GetByCandidateId", new { CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> AttachCandidateToReferralAsync(string referralCode, int candidateId)
    {
        using var c = Conn();
        var rows = await c.ExecuteScalarAsync<int>("sp_Referral_AttachCandidate", new { ReferralCode = referralCode, CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<IEnumerable<Referral>> GetReferralsByReferrerAsync(int referrerUserId)
    {
        using var c = Conn();
        return await c.QueryAsync<Referral>("sp_Referral_GetByReferrer", new { ReferrerUserId = referrerUserId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<Referral>> GetAllReferralsAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<Referral>("sp_Referral_GetAll", commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> UpdateReferralBonusAsync(int id, decimal? bonusAmount, string bonusStatus)
    {
        using var c = Conn();
        var rows = await c.ExecuteScalarAsync<int>("sp_Referral_UpdateBonus", new { Id = id, BonusAmount = bonusAmount, BonusStatus = bonusStatus }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }
}
