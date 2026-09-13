using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

public class SmtpSettingsRequest
{
    [Required, StringLength(50)]
    public string Provider { get; set; } = "Custom";

    [Required, StringLength(200)]
    public string Host { get; set; } = string.Empty;

    [Required, Range(1, 65535)]
    public int Port { get; set; } = 587;

    /// <summary>Auto, SslOnConnect, StartTls, StartTlsWhenAvailable, None.</summary>
    [Required, StringLength(20)]
    public string SecureSocketMode { get; set; } = "Auto";

    [Required, StringLength(256)]
    public string Username { get; set; } = string.Empty;

    /// <summary>Plaintext password from the admin UI - encrypted server-side before storage. Omit to keep the existing password.</summary>
    public string? Password { get; set; }

    [Required, EmailAddress, StringLength(256)]
    public string FromEmail { get; set; } = string.Empty;

    [StringLength(150)]
    public string? FromName { get; set; }
}

/// <summary>What the client sees for the active SMTP config - never the password.</summary>
public class SmtpSettingsDto
{
    public int Id { get; set; }
    public string Provider { get; set; } = string.Empty;
    public string Host { get; set; } = string.Empty;
    public int Port { get; set; }
    public string SecureSocketMode { get; set; } = string.Empty;
    public string Username { get; set; } = string.Empty;
    public string FromEmail { get; set; } = string.Empty;
    public string? FromName { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public bool HasPassword { get; set; }
}

public class SendTestEmailRequest
{
    [Required, EmailAddress]
    public string ToEmail { get; set; } = string.Empty;
}

public class EmailTemplateRequest
{
    [StringLength(80)]
    public string? Code { get; set; }

    [Required, StringLength(150)]
    public string Name { get; set; } = string.Empty;

    [Required, StringLength(300)]
    public string Subject { get; set; } = string.Empty;

    [Required]
    public string BodyHtml { get; set; } = string.Empty;

    [Required, StringLength(50)]
    public string Category { get; set; } = "General";

    public bool IsActive { get; set; } = true;
}

public class SendEmailRequest
{
    public int? CandidateId { get; set; }

    [EmailAddress]
    public string? ToEmail { get; set; }

    [Required, StringLength(80)]
    public string TemplateCode { get; set; } = string.Empty;

    /// <summary>Placeholder overrides beyond what's auto-filled from the candidate/job (e.g. ReasonNote, MeetingInfo).</summary>
    public Dictionary<string, string>? Placeholders { get; set; }
}
