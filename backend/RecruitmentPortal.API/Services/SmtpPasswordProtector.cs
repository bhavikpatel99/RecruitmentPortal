using Microsoft.AspNetCore.DataProtection;

namespace RecruitmentPortal.API.Services;

/// <summary>Encrypts/decrypts the SMTP account password at rest using ASP.NET Core Data Protection.</summary>
public interface ISmtpPasswordProtector
{
    string Protect(string plaintextPassword);
    string Unprotect(string encryptedPassword);
}

public sealed class SmtpPasswordProtector : ISmtpPasswordProtector
{
    private readonly IDataProtector _protector;

    public SmtpPasswordProtector(IDataProtectionProvider provider)
    {
        _protector = provider.CreateProtector("RecruitmentPortal.SmtpPassword.v1");
    }

    public string Protect(string plaintextPassword) => _protector.Protect(plaintextPassword);

    public string Unprotect(string encryptedPassword) => _protector.Unprotect(encryptedPassword);
}
