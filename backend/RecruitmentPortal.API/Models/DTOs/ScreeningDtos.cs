using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

public class ScreeningFormRequest
{
    public int? JobId { get; set; }

    [Required, StringLength(256)]
    public string Title { get; set; } = string.Empty;

    [StringLength(500)]
    public string? Description { get; set; }
}

public class ScreeningQuestionRequest
{
    [Required, StringLength(500)]
    public string QuestionText { get; set; } = string.Empty;

    [Required, StringLength(30)]
    public string QuestionType { get; set; } = "Text";

    [StringLength(500)]
    public string? Options { get; set; }

    public bool IsKnockout { get; set; }

    [StringLength(200)]
    public string? ExpectedAnswer { get; set; }

    public int SortOrder { get; set; }
}

public class ScreeningAnswerDto
{
    public int QuestionId { get; set; }
    public string? AnswerText { get; set; }
}

public class ScreeningResponseSubmitRequest
{
    [Required]
    public int CandidateId { get; set; }

    [Required]
    public int ScreeningFormId { get; set; }

    public string? RecruiterNotes { get; set; }

    public List<ScreeningAnswerDto> Answers { get; set; } = new();
}

public class ScreeningRecommendationRequest
{
    [Required, StringLength(20)]
    public string Recommendation { get; set; } = string.Empty; // Shortlist, Reject, Hold

    public int? OverallScore { get; set; }

    public string? RecruiterNotes { get; set; }
}
