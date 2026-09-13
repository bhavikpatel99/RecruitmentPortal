using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for dbo.Candidates and its pipeline stage history.</summary>
public sealed class CandidateRepository : ICandidateRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public CandidateRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<Candidate>> GetAllAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Candidate>(
            "sp_Candidate_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<Candidate>> GetByUserIdAsync(int userId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Candidate>(
            "sp_Candidate_GetByUserId",
            new { UserId = userId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<Candidate?> GetByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<Candidate>(
            "sp_Candidate_GetById",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateAsync(Candidate candidate)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_Candidate_Create",
            BuildParameters(candidate, includeId: false),
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> UpdateAsync(Candidate candidate)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Candidate_Update",
            BuildParameters(candidate, includeId: true),
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> UpdateResumeAsync(int id, string resumeUrl, string resumeFileName)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Candidate_UpdateResume",
            new { Id = id, ResumeUrl = resumeUrl, ResumeFileName = resumeFileName },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> DeleteAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Candidate_Delete",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> ChangeStageAsync(int candidateId, string newStatus, int? changedBy, string? reason, string? notes)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Candidate_ChangeStage",
            new { CandidateId = candidateId, NewStatus = newStatus, ChangedBy = changedBy, Reason = reason, Notes = notes },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<IEnumerable<CandidateStageHistory>> GetStageHistoryAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<CandidateStageHistory>(
            "sp_Candidate_GetStageHistory",
            new { CandidateId = candidateId },
            commandType: CommandType.StoredProcedure);
    }

    private static DynamicParameters BuildParameters(Candidate candidate, bool includeId)
    {
        var p = new DynamicParameters();
        if (includeId)
            p.Add("Id", candidate.Id);
        else
            p.Add("UserId", candidate.UserId);

        p.Add("JobId", candidate.JobId);
        p.Add("FirstName", candidate.FirstName);
        p.Add("MiddleName", candidate.MiddleName);
        p.Add("LastName", candidate.LastName);
        p.Add("Email", candidate.Email);
        p.Add("Phone", candidate.Phone);
        p.Add("AlternatePhone", candidate.AlternatePhone);
        p.Add("DateOfBirth", candidate.DateOfBirth);
        p.Add("Gender", candidate.Gender);
        p.Add("MaritalStatus", candidate.MaritalStatus);
        p.Add("Nationality", candidate.Nationality);
        p.Add("Address", candidate.Address);
        p.Add("City", candidate.City);
        p.Add("State", candidate.State);
        p.Add("Country", candidate.Country);
        p.Add("PostalCode", candidate.PostalCode);
        p.Add("PositionApplied", candidate.PositionApplied);
        p.Add("EmploymentType", candidate.EmploymentType);
        p.Add("TotalExperience", candidate.TotalExperience);
        p.Add("CurrentCompany", candidate.CurrentCompany);
        p.Add("CurrentCtc", candidate.CurrentCtc);
        p.Add("ExpectedCtc", candidate.ExpectedCtc);
        p.Add("NoticePeriodDays", candidate.NoticePeriodDays);
        p.Add("PreferredLocation", candidate.PreferredLocation);
        p.Add("WillingToRelocate", candidate.WillingToRelocate);
        p.Add("AvailableFrom", candidate.AvailableFrom);
        p.Add("HighestQualification", candidate.HighestQualification);
        p.Add("Skills", candidate.Skills);
        p.Add("LinkedInUrl", candidate.LinkedInUrl);
        p.Add("PortfolioUrl", candidate.PortfolioUrl);
        p.Add("GitHubUrl", candidate.GitHubUrl);
        p.Add("ResumeUrl", candidate.ResumeUrl);
        p.Add("CoverLetter", candidate.CoverLetter);
        p.Add("ReferenceName", candidate.ReferenceName);
        p.Add("ReferenceContact", candidate.ReferenceContact);
        p.Add("Source", candidate.Source);
        p.Add("Status", candidate.Status);
        return p;
    }
}
