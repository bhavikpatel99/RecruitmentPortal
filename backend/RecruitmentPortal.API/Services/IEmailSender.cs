namespace RecruitmentPortal.API.Services;

public record EmailSendResult(bool Success, string? ErrorMessage);

/// <summary>
/// Sends email over SMTP using whatever provider is currently configured in the database
/// (Gmail, Zoho, Zimbra, Office365, or any other SMTP server) - no provider is hard-coded.
/// </summary>
public interface IEmailSender
{
    Task<EmailSendResult> SendAsync(string toEmail, string subject, string htmlBody);
}
