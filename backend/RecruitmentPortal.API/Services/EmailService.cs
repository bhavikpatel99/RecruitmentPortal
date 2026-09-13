using System.Text.RegularExpressions;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Services;

public sealed class EmailService : IEmailService
{
    private readonly ICommunicationRepository _repository;
    private readonly IEmailSender _sender;
    private readonly ILogger<EmailService> _logger;
    private const string CompanyName = "Recruitment Portal";

    public EmailService(ICommunicationRepository repository, IEmailSender sender, ILogger<EmailService> logger)
    {
        _repository = repository;
        _sender = sender;
        _logger = logger;
    }

    public async Task SendTemplatedEmailAsync(string templateCode, string toEmail, Dictionary<string, string>? placeholders = null, int? candidateId = null, int? sentBy = null)
    {
        try
        {
            var template = await _repository.GetTemplateByCodeAsync(templateCode);
            if (template is null || !template.IsActive)
            {
                _logger.LogWarning("Email template {TemplateCode} not found or inactive - skipping send to {ToEmail}", templateCode, toEmail);
                return;
            }

            var merged = new Dictionary<string, string>(placeholders ?? new(), StringComparer.OrdinalIgnoreCase)
            {
                ["CompanyName"] = CompanyName
            };

            var subject = Merge(template.Subject, merged);
            var body = Merge(template.BodyHtml, merged);

            var logId = await _repository.CreateEmailLogAsync(new EmailLog
            {
                ToEmail = toEmail,
                Subject = subject,
                Body = body,
                TemplateCode = templateCode,
                CandidateId = candidateId,
                SentBy = sentBy
            });

            var result = await _sender.SendAsync(toEmail, subject, body);
            await _repository.MarkEmailResultAsync(logId, result.Success ? "Sent" : "Failed", result.ErrorMessage);
        }
        catch (Exception ex)
        {
            // Notifications are best-effort: never let an email failure break the calling workflow.
            _logger.LogError(ex, "Unexpected error sending templated email {TemplateCode} to {ToEmail}", templateCode, toEmail);
        }
    }

    private static string Merge(string template, Dictionary<string, string> values)
    {
        return Regex.Replace(template, @"\{\{(\w+)\}\}", match =>
        {
            var key = match.Groups[1].Value;
            return values.TryGetValue(key, out var value) ? value : string.Empty;
        });
    }
}
