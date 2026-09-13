using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for SMTP settings, email templates, and the send log.</summary>
public sealed class CommunicationRepository : ICommunicationRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public CommunicationRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<int> UpsertSmtpSettingsAsync(SmtpSettings settings)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_SmtpSettings_Upsert",
            new
            {
                settings.Provider,
                settings.Host,
                settings.Port,
                settings.SecureSocketMode,
                settings.Username,
                settings.EncryptedPassword,
                settings.FromEmail,
                settings.FromName,
                settings.CreatedBy
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<SmtpSettings?> GetActiveSmtpSettingsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<SmtpSettings>(
            "sp_SmtpSettings_GetActive", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<EmailTemplate>> GetAllTemplatesAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<EmailTemplate>("sp_EmailTemplate_GetAll", commandType: CommandType.StoredProcedure);
    }

    public async Task<EmailTemplate?> GetTemplateByCodeAsync(string code)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<EmailTemplate>(
            "sp_EmailTemplate_GetByCode", new { Code = code }, commandType: CommandType.StoredProcedure);
    }

    public async Task<EmailTemplate?> GetTemplateByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<EmailTemplate>(
            "sp_EmailTemplate_GetById", new { Id = id }, commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateTemplateAsync(EmailTemplate template)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_EmailTemplate_Create",
            new { template.Code, template.Name, template.Subject, template.BodyHtml, template.Category, template.IsSystem, template.CreatedBy },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> UpdateTemplateAsync(EmailTemplate template)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_EmailTemplate_Update",
            new { template.Id, template.Name, template.Subject, template.BodyHtml, template.Category, template.IsActive },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> DeleteTemplateAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_EmailTemplate_Delete", new { Id = id }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<int> CreateEmailLogAsync(EmailLog log)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_EmailLog_Create",
            new { log.ToEmail, log.Subject, log.Body, log.TemplateCode, log.CandidateId, log.SentBy },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> MarkEmailResultAsync(int id, string status, string? errorMessage)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_EmailLog_MarkResult", new { Id = id, Status = status, ErrorMessage = errorMessage }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<IEnumerable<EmailLog>> GetAllEmailLogsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<EmailLog>("sp_EmailLog_GetAll", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<EmailLog>> GetEmailLogsByCandidateIdAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<EmailLog>(
            "sp_EmailLog_GetByCandidateId", new { CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
    }
}
