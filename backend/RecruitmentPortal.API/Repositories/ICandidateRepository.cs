using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface ICandidateRepository
{
    Task<IEnumerable<Candidate>> GetAllAsync();
    Task<IEnumerable<Candidate>> GetByUserIdAsync(int userId);
    Task<Candidate?> GetByIdAsync(int id);
    Task<int> CreateAsync(Candidate candidate);
    Task<bool> UpdateAsync(Candidate candidate);
    Task<bool> UpdateResumeAsync(int id, string resumeUrl, string resumeFileName);
    Task<bool> DeleteAsync(int id);
    Task<bool> ChangeStageAsync(int candidateId, string newStatus, int? changedBy, string? reason, string? notes);
    Task<IEnumerable<CandidateStageHistory>> GetStageHistoryAsync(int candidateId);
}
