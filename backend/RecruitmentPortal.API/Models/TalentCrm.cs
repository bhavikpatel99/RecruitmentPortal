namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.CandidateNotes (spec module 10: candidate 360).</summary>
public class CandidateNote
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public string Note { get; set; } = string.Empty;
    public int? CreatedBy { get; set; }
    public string? CreatedByName { get; set; }
    public DateTime CreatedAt { get; set; }
}

/// <summary>Maps to dbo.CandidateTags.</summary>
public class CandidateTag
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public string Tag { get; set; } = string.Empty;
    public int? CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
}

/// <summary>Maps to dbo.TalentPools.</summary>
public class TalentPool
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public int? CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int MemberCount { get; set; }
}

/// <summary>Result row for dbo.TalentPoolMembers joined to Candidates.</summary>
public class TalentPoolMember
{
    public int Id { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? PositionApplied { get; set; }
    public decimal? TotalExperience { get; set; }
    public string? Skills { get; set; }
    public string? Status { get; set; }
    public DateTime AddedAt { get; set; }
}

/// <summary>A pool a given candidate belongs to.</summary>
public class TalentPoolSummary
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
}

/// <summary>Result row for dbo.sp_Candidate_Search.</summary>
public class CandidateSearchResult
{
    public int Id { get; set; }
    public int? UserId { get; set; }
    public int? JobId { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string? MiddleName { get; set; }
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? Phone { get; set; }
    public string? PositionApplied { get; set; }
    public string? EmploymentType { get; set; }
    public decimal? TotalExperience { get; set; }
    public string? CurrentCompany { get; set; }
    public decimal? ExpectedCtc { get; set; }
    public string? PreferredLocation { get; set; }
    public string? City { get; set; }
    public string? Country { get; set; }
    public string? Skills { get; set; }
    public string? Source { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}

/// <summary>Maps to dbo.SavedSearches.</summary>
public class SavedSearch
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Keyword { get; set; }
    public decimal? MinExperience { get; set; }
    public decimal? MaxExperience { get; set; }
    public string? Location { get; set; }
    public string? Status { get; set; }
    public string? Source { get; set; }
    public DateTime CreatedAt { get; set; }
}
