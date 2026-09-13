using System.Data;
using System.Text.Json;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for screening forms, questions and responses.</summary>
public sealed class ScreeningRepository : IScreeningRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public ScreeningRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<int> CreateFormAsync(ScreeningForm form)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_ScreeningForm_Create",
            new { form.JobId, form.Title, form.Description, form.CreatedBy },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<ScreeningForm>> GetAllFormsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<ScreeningForm>(
            "sp_ScreeningForm_GetAll",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<ScreeningForm?> GetFormByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<ScreeningForm>(
            "sp_ScreeningForm_GetById",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<int> AddQuestionAsync(int formId, ScreeningQuestionRequest question)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_ScreeningQuestion_Add",
            new
            {
                ScreeningFormId = formId,
                question.QuestionText,
                question.QuestionType,
                question.Options,
                question.IsKnockout,
                question.ExpectedAnswer,
                question.SortOrder
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<ScreeningQuestion>> GetQuestionsByFormIdAsync(int formId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<ScreeningQuestion>(
            "sp_ScreeningQuestion_GetByFormId",
            new { ScreeningFormId = formId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> DeleteQuestionAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_ScreeningQuestion_Delete",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<int> SubmitResponseAsync(int candidateId, int formId, int? evaluatedBy, string? notes, List<ScreeningAnswerDto> answers)
    {
        using var connection = _connectionFactory.CreateConnection();
        var answersJson = JsonSerializer.Serialize(answers);
        return await connection.ExecuteScalarAsync<int>(
            "sp_ScreeningResponse_Submit",
            new
            {
                CandidateId = candidateId,
                ScreeningFormId = formId,
                EvaluatedBy = evaluatedBy,
                RecruiterNotes = notes,
                AnswersJson = answersJson
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<ScreeningResponse?> GetResponseByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<ScreeningResponse>(
            "sp_ScreeningResponse_GetById", new { Id = id }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<ScreeningResponse>> GetResponsesByCandidateIdAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<ScreeningResponse>(
            "sp_ScreeningResponse_GetByCandidateId",
            new { CandidateId = candidateId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<ScreeningAnswer>> GetAnswersAsync(int responseId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<ScreeningAnswer>(
            "sp_ScreeningResponse_GetAnswers",
            new { ScreeningResponseId = responseId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> UpdateRecommendationAsync(int id, string recommendation, int? overallScore, string? notes, int? evaluatedBy)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_ScreeningResponse_UpdateRecommendation",
            new { Id = id, Recommendation = recommendation, OverallScore = overallScore, RecruiterNotes = notes, EvaluatedBy = evaluatedBy },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }
}
