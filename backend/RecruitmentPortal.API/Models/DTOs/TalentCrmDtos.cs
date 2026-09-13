using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

public class CandidateNoteRequest
{
    [Required]
    public string Note { get; set; } = string.Empty;
}

public class CandidateTagRequest
{
    [Required, StringLength(50)]
    public string Tag { get; set; } = string.Empty;
}

public class TalentPoolRequest
{
    [Required, StringLength(150)]
    public string Name { get; set; } = string.Empty;

    [StringLength(500)]
    public string? Description { get; set; }
}

public class CandidateSearchRequest
{
    public string? Keyword { get; set; }
    public decimal? MinExperience { get; set; }
    public decimal? MaxExperience { get; set; }
    public string? Location { get; set; }
    public string? Status { get; set; }
    public string? Source { get; set; }
    public string? Tag { get; set; }
}

public class SavedSearchRequest
{
    [Required, StringLength(150)]
    public string Name { get; set; } = string.Empty;

    public string? Keyword { get; set; }
    public decimal? MinExperience { get; set; }
    public decimal? MaxExperience { get; set; }
    public string? Location { get; set; }
    public string? Status { get; set; }
    public string? Source { get; set; }
}
