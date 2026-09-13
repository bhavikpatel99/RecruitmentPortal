using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface IAssessmentRepository
{
    Task<int> CreateTemplateAsync(AssessmentTemplate template);
    Task<IEnumerable<AssessmentTemplate>> GetAllTemplatesAsync();
    Task<AssessmentTemplate?> GetTemplateByIdAsync(int id);
    Task<bool> DeleteTemplateAsync(int id);

    Task<int> CreateInvitationAsync(int candidateId, int templateId, int? invitedBy, DateTime? deadline);
    Task<AssessmentInvitation?> GetInvitationByIdAsync(int id);
    Task<IEnumerable<AssessmentInvitation>> GetAllInvitationsAsync();
    Task<IEnumerable<AssessmentInvitation>> GetInvitationsByCandidateIdAsync(int candidateId);
    Task<bool> RecordResultAsync(int id, int score, string? notes, int? performedBy);
    Task<bool> UpdateStatusAsync(int id, string status);
}
