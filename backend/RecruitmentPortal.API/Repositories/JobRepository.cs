using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for dbo.Jobs (includes JD Builder fields and publishing channels).</summary>
public sealed class JobRepository : IJobRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public JobRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<Job>> GetAllAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Job>(
            "sp_Job_GetAllFull",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<Job?> GetByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<Job>(
            "sp_Job_GetByIdFull",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<Job>> GetOpenJobsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Job>(
            "sp_Job_GetOpen",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateAsync(Job job)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_Job_CreateFull",
            new
            {
                job.Title,
                job.Description,
                job.Requirements,
                job.Responsibilities,
                job.Location,
                job.EmploymentType,
                job.SalaryMin,
                job.SalaryMax,
                job.ExperienceYearsMin,
                job.ExperienceYearsMax,
                job.Skills,
                job.Department,
                job.Status,
                job.PostedDate,
                job.PostedBy,
                job.MustHaveSkills,
                job.NiceToHaveSkills,
                job.EducationRequirement,
                job.WorkMode,
                job.BenefitsText,
                job.LegalText,
                job.JobRequisitionId
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> UpdateAsync(Job job)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Job_UpdateFull",
            new
            {
                job.Id,
                job.Title,
                job.Description,
                job.Requirements,
                job.Responsibilities,
                job.Location,
                job.EmploymentType,
                job.SalaryMin,
                job.SalaryMax,
                job.ExperienceYearsMin,
                job.ExperienceYearsMax,
                job.Skills,
                job.Department,
                job.Status,
                job.ClosedDate,
                job.MustHaveSkills,
                job.NiceToHaveSkills,
                job.EducationRequirement,
                job.WorkMode,
                job.BenefitsText,
                job.LegalText
            },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> DeleteAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Job_Delete",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<int> AddPostingChannelAsync(int jobId, string channel, string? externalUrl, DateTime? expiryDate, int? createdBy)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_JobPostingChannel_Add",
            new { JobId = jobId, Channel = channel, ExternalUrl = externalUrl, ExpiryDate = expiryDate, CreatedBy = createdBy },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<JobPostingChannel>> GetPostingChannelsAsync(int jobId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<JobPostingChannel>(
            "sp_JobPostingChannel_GetByJobId", new { JobId = jobId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> UpdatePostingChannelStatusAsync(int id, string status)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_JobPostingChannel_UpdateStatus", new { Id = id, Status = status }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }
}
