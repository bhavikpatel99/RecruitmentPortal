namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.SmtpSettings. EncryptedPassword is protected via ASP.NET Core Data Protection - never returned to clients.</summary>
public class SmtpSettings
{
    public int Id { get; set; }
    public string Provider { get; set; } = "Custom";
    public string Host { get; set; } = string.Empty;
    public int Port { get; set; } = 587;
    public string SecureSocketMode { get; set; } = "Auto";
    public string Username { get; set; } = string.Empty;
    public string EncryptedPassword { get; set; } = string.Empty;
    public string FromEmail { get; set; } = string.Empty;
    public string? FromName { get; set; }
    public bool IsActive { get; set; } = true;
    public int? CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

/// <summary>Maps to dbo.EmailTemplates.</summary>
public class EmailTemplate
{
    public int Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Subject { get; set; } = string.Empty;
    public string BodyHtml { get; set; } = string.Empty;
    public string Category { get; set; } = "General";
    public bool IsSystem { get; set; }
    public bool IsActive { get; set; } = true;
    public int? CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

/// <summary>Maps to dbo.EmailLog - the communication audit trail.</summary>
public class EmailLog
{
    public int Id { get; set; }
    public string ToEmail { get; set; } = string.Empty;
    public string Subject { get; set; } = string.Empty;
    public string? Body { get; set; }
    public string? TemplateCode { get; set; }
    public int? CandidateId { get; set; }
    public string Status { get; set; } = "Pending";
    public string? ErrorMessage { get; set; }
    public int? SentBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? SentAt { get; set; }
}
