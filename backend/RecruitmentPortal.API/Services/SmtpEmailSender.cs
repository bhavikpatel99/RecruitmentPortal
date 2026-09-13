using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Services;

/// <summary>
/// Generic SMTP sender built on MailKit. Reads the active provider configuration from the
/// database at send time, so switching between Gmail, Zoho, Zimbra, Office365, or a custom
/// server is a config change in the Admin UI, never a code change or redeploy.
/// </summary>
public sealed class SmtpEmailSender : IEmailSender
{
    private readonly ICommunicationRepository _repository;
    private readonly ISmtpPasswordProtector _passwordProtector;
    private readonly ILogger<SmtpEmailSender> _logger;

    public SmtpEmailSender(ICommunicationRepository repository, ISmtpPasswordProtector passwordProtector, ILogger<SmtpEmailSender> logger)
    {
        _repository = repository;
        _passwordProtector = passwordProtector;
        _logger = logger;
    }

    public async Task<EmailSendResult> SendAsync(string toEmail, string subject, string htmlBody)
    {
        var settings = await _repository.GetActiveSmtpSettingsAsync();
        if (settings is null)
        {
            return new EmailSendResult(false, "No SMTP provider is configured. Set one up under Communication > SMTP Settings.");
        }

        try
        {
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(settings.FromName ?? settings.FromEmail, settings.FromEmail));
            message.To.Add(MailboxAddress.Parse(toEmail));
            message.Subject = subject;
            message.Body = new TextPart("html") { Text = htmlBody };

            var password = _passwordProtector.Unprotect(settings.EncryptedPassword);
            var secureOption = ParseSecureSocketOptions(settings.SecureSocketMode);

            using var client = new SmtpClient();
            await client.ConnectAsync(settings.Host, settings.Port, secureOption);
            await client.AuthenticateAsync(settings.Username, password);
            await client.SendAsync(message);
            await client.DisconnectAsync(true);

            return new EmailSendResult(true, null);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send email to {ToEmail}", toEmail);
            return new EmailSendResult(false, ex.Message);
        }
    }

    private static SecureSocketOptions ParseSecureSocketOptions(string mode) => mode switch
    {
        "SslOnConnect" => SecureSocketOptions.SslOnConnect,
        "StartTls" => SecureSocketOptions.StartTls,
        "StartTlsWhenAvailable" => SecureSocketOptions.StartTlsWhenAvailable,
        "None" => SecureSocketOptions.None,
        _ => SecureSocketOptions.Auto
    };
}
