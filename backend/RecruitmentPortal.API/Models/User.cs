namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.Users.</summary>
public class User
{
    public int Id { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string Role { get; set; } = "Candidate";
    public int? AgencyId { get; set; }
    public DateTime CreatedAt { get; set; }
}
