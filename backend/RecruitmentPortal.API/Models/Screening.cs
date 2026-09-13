namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.ScreeningForms (spec module 13).</summary>
public class ScreeningForm
{
    public int Id { get; set; }
    public int? JobId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;
    public int? CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
}

/// <summary>Maps to dbo.ScreeningQuestions.</summary>
public class ScreeningQuestion
{
    public int Id { get; set; }
    public int ScreeningFormId { get; set; }
    public string QuestionText { get; set; } = string.Empty;
    public string QuestionType { get; set; } = "Text";
    public string? Options { get; set; }
    public bool IsKnockout { get; set; }
    public string? ExpectedAnswer { get; set; }
    public int SortOrder { get; set; }
}

/// <summary>Maps to dbo.ScreeningResponses.</summary>
public class ScreeningResponse
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public int ScreeningFormId { get; set; }
    public string? FormTitle { get; set; }
    public DateTime SubmittedAt { get; set; }
    public bool KnockoutFailed { get; set; }
    public int? OverallScore { get; set; }
    public string? Recommendation { get; set; }
    public string? RecruiterNotes { get; set; }
    public int? EvaluatedBy { get; set; }
    public DateTime? EvaluatedAt { get; set; }
}

/// <summary>Maps to dbo.ScreeningAnswers.</summary>
public class ScreeningAnswer
{
    public int Id { get; set; }
    public int ScreeningResponseId { get; set; }
    public int QuestionId { get; set; }
    public string? QuestionText { get; set; }
    public bool IsKnockout { get; set; }
    public string? AnswerText { get; set; }
    public bool? PassedKnockout { get; set; }
}
