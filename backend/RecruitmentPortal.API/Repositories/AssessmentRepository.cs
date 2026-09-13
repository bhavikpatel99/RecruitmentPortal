using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for assessment templates and invitations.</summary>
public sealed class AssessmentRepository : IAssessmentRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public AssessmentRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<int> CreateTemplateAsync(AssessmentTemplate template)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_AssessmentTemplate_Create",
            new
            {
                template.Title,
                template.AssessmentType,
                template.Description,
                template.VendorName,
                template.ExternalLink,
                template.PassingScore,
                template.DurationMinutes,
                template.CreatedBy
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AssessmentTemplate>> GetAllTemplatesAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<AssessmentTemplate>(
            "sp_AssessmentTemplate_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<AssessmentTemplate?> GetTemplateByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<AssessmentTemplate>(
            "sp_AssessmentTemplate_GetById",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> DeleteTemplateAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_AssessmentTemplate_Delete",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<int> CreateInvitationAsync(int candidateId, int templateId, int? invitedBy, DateTime? deadline)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_AssessmentInvitation_Create",
            new { CandidateId = candidateId, AssessmentTemplateId = templateId, InvitedBy = invitedBy, Deadline = deadline },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<AssessmentInvitation?> GetInvitationByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<AssessmentInvitation>(
            "sp_AssessmentInvitation_GetById", new { Id = id }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AssessmentInvitation>> GetAllInvitationsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<AssessmentInvitation>(
            "sp_AssessmentInvitation_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AssessmentInvitation>> GetInvitationsByCandidateIdAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<AssessmentInvitation>(
            "sp_AssessmentInvitation_GetByCandidateId",
            new { CandidateId = candidateId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> RecordResultAsync(int id, int score, string? notes, int? performedBy)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_AssessmentInvitation_RecordResult",
            new { Id = id, Score = score, Notes = notes, PerformedBy = performedBy },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> UpdateStatusAsync(int id, string status)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_AssessmentInvitation_UpdateStatus",
            new { Id = id, Status = status },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }
}
