namespace RecruitmentPortal.API.Services;

/// <summary>
/// Template-aware email sending used throughout the app (application received, interview
/// scheduled, offer sent, rejection notice, etc). Never throws - a notification failure must
/// never break the underlying business action (creating a candidate, scheduling an interview...).
/// Every attempt is written to the EmailLog audit trail regardless of outcome.
/// </summary>
public interface IEmailService
{
    Task SendTemplatedEmailAsync(string templateCode, string toEmail, Dictionary<string, string>? placeholders = null, int? candidateId = null, int? sentBy = null);
}
