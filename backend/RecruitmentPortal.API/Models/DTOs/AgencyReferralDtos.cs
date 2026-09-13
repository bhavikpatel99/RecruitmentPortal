using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

public class AgencyRequest
{
    [Required, StringLength(150)]
    public string Name { get; set; } = string.Empty;

    [EmailAddress, StringLength(256)]
    public string? ContactEmail { get; set; }

    [StringLength(30)]
    public string? ContactPhone { get; set; }
}

public class AgencyUserRequest
{
    [Required]
    public int AgencyId { get; set; }

    [Required, StringLength(150)]
    public string FullName { get; set; } = string.Empty;

    [Required, EmailAddress, StringLength(256)]
    public string Email { get; set; } = string.Empty;

    [Required, StringLength(100, MinimumLength = 8)]
    [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$",
        ErrorMessage = "Password must be at least 8 characters and include an uppercase letter, a lowercase letter, and a digit.")]
    public string Password { get; set; } = string.Empty;
}

/// <summary>An agency submits a candidate for a job using the same fields as a normal application.</summary>
public class AgencySubmissionRequest : CandidateRequest
{
    public int? JobId { get; set; }
}

public class ReferralLinkRequest
{
    [Required]
    public int JobId { get; set; }
}

public class ReferralBonusRequest
{
    public decimal? BonusAmount { get; set; }

    [Required, StringLength(20)]
    public string BonusStatus { get; set; } = string.Empty; // NotEligible, Pending, Approved, Paid
}
