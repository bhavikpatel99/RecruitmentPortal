using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for organization master data (spec module 2).</summary>
public sealed class OrgSetupRepository : IOrgSetupRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public OrgSetupRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    private IDbConnection Conn() => _connectionFactory.CreateConnection();

    public async Task<IEnumerable<Department>> GetDepartmentsAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<Department>("sp_Department_GetAll", commandType: CommandType.StoredProcedure);
    }
    public async Task<int> CreateDepartmentAsync(string name)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_Department_Create", new { Name = name }, commandType: CommandType.StoredProcedure);
    }
    public async Task<bool> DeleteDepartmentAsync(int id)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_Department_Delete", new { Id = id }, commandType: CommandType.StoredProcedure) > 0;
    }

    public async Task<IEnumerable<OfficeLocation>> GetLocationsAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<OfficeLocation>("sp_OfficeLocation_GetAll", commandType: CommandType.StoredProcedure);
    }
    public async Task<int> CreateLocationAsync(string name, string? city, string? country)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_OfficeLocation_Create", new { Name = name, City = city, Country = country }, commandType: CommandType.StoredProcedure);
    }
    public async Task<bool> DeleteLocationAsync(int id)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_OfficeLocation_Delete", new { Id = id }, commandType: CommandType.StoredProcedure) > 0;
    }

    public async Task<IEnumerable<JobFamily>> GetJobFamiliesAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<JobFamily>("sp_JobFamily_GetAll", commandType: CommandType.StoredProcedure);
    }
    public async Task<int> CreateJobFamilyAsync(string name, string? description)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_JobFamily_Create", new { Name = name, Description = description }, commandType: CommandType.StoredProcedure);
    }
    public async Task<bool> DeleteJobFamilyAsync(int id)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_JobFamily_Delete", new { Id = id }, commandType: CommandType.StoredProcedure) > 0;
    }

    public async Task<IEnumerable<SkillMaster>> GetSkillsAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<SkillMaster>("sp_SkillMaster_GetAll", commandType: CommandType.StoredProcedure);
    }
    public async Task<int> CreateSkillAsync(string name, string? category)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_SkillMaster_Create", new { Name = name, Category = category }, commandType: CommandType.StoredProcedure);
    }
    public async Task<bool> DeleteSkillAsync(int id)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_SkillMaster_Delete", new { Id = id }, commandType: CommandType.StoredProcedure) > 0;
    }

    public async Task<IEnumerable<Competency>> GetCompetenciesAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<Competency>("sp_Competency_GetAll", commandType: CommandType.StoredProcedure);
    }
    public async Task<int> CreateCompetencyAsync(string name, string? description)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_Competency_Create", new { Name = name, Description = description }, commandType: CommandType.StoredProcedure);
    }
    public async Task<bool> DeleteCompetencyAsync(int id)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_Competency_Delete", new { Id = id }, commandType: CommandType.StoredProcedure) > 0;
    }

    public async Task<IEnumerable<SalaryBand>> GetSalaryBandsAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<SalaryBand>("sp_SalaryBand_GetAll", commandType: CommandType.StoredProcedure);
    }
    public async Task<int> CreateSalaryBandAsync(int? jobFamilyId, string level, decimal minSalary, decimal maxSalary, string currency)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_SalaryBand_Create",
            new { JobFamilyId = jobFamilyId, Level = level, MinSalary = minSalary, MaxSalary = maxSalary, Currency = currency },
            commandType: CommandType.StoredProcedure);
    }
    public async Task<bool> DeleteSalaryBandAsync(int id)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_SalaryBand_Delete", new { Id = id }, commandType: CommandType.StoredProcedure) > 0;
    }

    public async Task<IEnumerable<ApprovalMatrix>> GetApprovalMatricesAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<ApprovalMatrix>("sp_ApprovalMatrix_GetAll", commandType: CommandType.StoredProcedure);
    }
    public async Task<int> CreateApprovalMatrixAsync(string name, string? description, decimal? minAmount, decimal? maxAmount, string requiredApproverRole)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_ApprovalMatrix_Create",
            new { Name = name, Description = description, MinAmount = minAmount, MaxAmount = maxAmount, RequiredApproverRole = requiredApproverRole },
            commandType: CommandType.StoredProcedure);
    }
    public async Task<bool> DeleteApprovalMatrixAsync(int id)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_ApprovalMatrix_Delete", new { Id = id }, commandType: CommandType.StoredProcedure) > 0;
    }

    public async Task<IEnumerable<InterviewPanelMaster>> GetInterviewPanelsAsync()
    {
        using var c = Conn();
        return await c.QueryAsync<InterviewPanelMaster>("sp_InterviewPanelMaster_GetAll", commandType: CommandType.StoredProcedure);
    }
    public async Task<int> CreateInterviewPanelAsync(string name, string? description, int? createdBy)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_InterviewPanelMaster_Create", new { Name = name, Description = description, CreatedBy = createdBy }, commandType: CommandType.StoredProcedure);
    }
    public async Task<bool> DeleteInterviewPanelAsync(int id)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_InterviewPanelMaster_Delete", new { Id = id }, commandType: CommandType.StoredProcedure) > 0;
    }
    public async Task<IEnumerable<InterviewPanelMasterMember>> GetInterviewPanelMembersAsync(int panelId)
    {
        using var c = Conn();
        return await c.QueryAsync<InterviewPanelMasterMember>("sp_InterviewPanelMaster_GetMembers", new { PanelId = panelId }, commandType: CommandType.StoredProcedure);
    }
    public async Task AddInterviewPanelMemberAsync(int panelId, int userId)
    {
        using var c = Conn();
        await c.ExecuteScalarAsync<int>("sp_InterviewPanelMaster_AddMember", new { PanelId = panelId, UserId = userId }, commandType: CommandType.StoredProcedure);
    }
    public async Task<bool> RemoveInterviewPanelMemberAsync(int panelId, int userId)
    {
        using var c = Conn();
        return await c.ExecuteScalarAsync<int>("sp_InterviewPanelMaster_RemoveMember", new { PanelId = panelId, UserId = userId }, commandType: CommandType.StoredProcedure) > 0;
    }
}
