namespace RecruitmentPortal.API.Models.DTOs;

/// <summary>Safe, non-sensitive projection of a user - never includes PasswordHash.</summary>
public class UserSummaryDto
{
    public int Id { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Role { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}
