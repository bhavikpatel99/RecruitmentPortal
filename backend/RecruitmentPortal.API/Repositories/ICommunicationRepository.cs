using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface ICommunicationRepository
{
    Task<int> UpsertSmtpSettingsAsync(SmtpSettings settings);
    Task<SmtpSettings?> GetActiveSmtpSettingsAsync();

    Task<IEnumerable<EmailTemplate>> GetAllTemplatesAsync();
    Task<EmailTemplate?> GetTemplateByCodeAsync(string code);
    Task<EmailTemplate?> GetTemplateByIdAsync(int id);
    Task<int> CreateTemplateAsync(EmailTemplate template);
    Task<bool> UpdateTemplateAsync(EmailTemplate template);
    Task<bool> DeleteTemplateAsync(int id);

    Task<int> CreateEmailLogAsync(EmailLog log);
    Task<bool> MarkEmailResultAsync(int id, string status, string? errorMessage);
    Task<IEnumerable<EmailLog>> GetAllEmailLogsAsync();
    Task<IEnumerable<EmailLog>> GetEmailLogsByCandidateIdAsync(int candidateId);
}
