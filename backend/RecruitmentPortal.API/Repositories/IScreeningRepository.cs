using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;

namespace RecruitmentPortal.API.Repositories;

public interface IScreeningRepository
{
    Task<int> CreateFormAsync(ScreeningForm form);
    Task<IEnumerable<ScreeningForm>> GetAllFormsAsync();
    Task<ScreeningForm?> GetFormByIdAsync(int id);

    Task<int> AddQuestionAsync(int formId, ScreeningQuestionRequest question);
    Task<IEnumerable<ScreeningQuestion>> GetQuestionsByFormIdAsync(int formId);
    Task<bool> DeleteQuestionAsync(int id);

    Task<int> SubmitResponseAsync(int candidateId, int formId, int? evaluatedBy, string? notes, List<ScreeningAnswerDto> answers);
    Task<ScreeningResponse?> GetResponseByIdAsync(int id);
    Task<IEnumerable<ScreeningResponse>> GetResponsesByCandidateIdAsync(int candidateId);
    Task<IEnumerable<ScreeningAnswer>> GetAnswersAsync(int responseId);
    Task<bool> UpdateRecommendationAsync(int id, string recommendation, int? overallScore, string? notes, int? evaluatedBy);
}
