using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for dbo.JobRequisitions and its audit trail.</summary>
public sealed class JobRequisitionRepository : IJobRequisitionRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public JobRequisitionRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<JobRequisition>> GetAllAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<JobRequisition>(
            "sp_JobRequisition_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<JobRequisition?> GetByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<JobRequisition>(
            "sp_JobRequisition_GetById",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateAsync(JobRequisition requisition)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_JobRequisition_Create",
            new
            {
                requisition.Title,
                requisition.Department,
                requisition.Location,
                requisition.EmploymentType,
                requisition.Vacancies,
                requisition.Priority,
                requisition.RequisitionType,
                requisition.TargetJoiningDate,
                requisition.BudgetReference,
                requisition.JustificationNotes,
                requisition.RequiredSkills,
                requisition.HiringManagerId,
                requisition.RecruiterId,
                requisition.CreatedBy
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> UpdateAsync(JobRequisition requisition)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_JobRequisition_Update",
            new
            {
                requisition.Id,
                requisition.Title,
                requisition.Department,
                requisition.Location,
                requisition.EmploymentType,
                requisition.Vacancies,
                requisition.Priority,
                requisition.RequisitionType,
                requisition.TargetJoiningDate,
                requisition.BudgetReference,
                requisition.JustificationNotes,
                requisition.RequiredSkills,
                requisition.HiringManagerId,
                requisition.RecruiterId,
                requisition.JobId
            },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> UpdateStatusAsync(int id, string newStatus, int? performedBy, string? rejectionReason, string? notes)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_JobRequisition_UpdateStatus",
            new { Id = id, NewStatus = newStatus, PerformedBy = performedBy, RejectionReason = rejectionReason, Notes = notes },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> LinkJobAsync(int id, int jobId)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_JobRequisition_LinkJob",
            new { Id = id, JobId = jobId },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<IEnumerable<JobRequisitionAudit>> GetAuditAsync(int jobRequisitionId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<JobRequisitionAudit>(
            "sp_JobRequisition_GetAudit",
            new { JobRequisitionId = jobRequisitionId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_JobRequisition_Delete",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }
}
