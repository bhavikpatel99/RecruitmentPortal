namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.Agencies (spec module 18).</summary>
public class Agency
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? ContactEmail { get; set; }
    public string? ContactPhone { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; }
}

public class AgencyDuplicateCheck
{
    public int Id { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? Source { get; set; }
}

/// <summary>Maps to dbo.AgencySubmissions.</summary>
public class AgencySubmission
{
    public int Id { get; set; }
    public int AgencyId { get; set; }
    public string? AgencyName { get; set; }
    public int? JobId { get; set; }
    public string? JobTitle { get; set; }
    public int? CandidateId { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? CandidateStatus { get; set; }
    public int SubmittedBy { get; set; }
    public DateTime SubmittedAt { get; set; }
    public bool WasDuplicate { get; set; }
}

public class AgencyPerformance
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int TotalSubmissions { get; set; }
    public int DuplicateSubmissions { get; set; }
    public int Hires { get; set; }
}

/// <summary>Maps to dbo.Referrals (spec module 19).</summary>
public class Referral
{
    public int Id { get; set; }
    public int ReferrerUserId { get; set; }
    public string? ReferrerName { get; set; }
    public int JobId { get; set; }
    public string? JobTitle { get; set; }
    public int? CandidateId { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string ReferralCode { get; set; } = string.Empty;
    public string Status { get; set; } = "LinkGenerated";
    public decimal? BonusAmount { get; set; }
    public string BonusStatus { get; set; } = "NotEligible";
    public DateTime CreatedAt { get; set; }
}
