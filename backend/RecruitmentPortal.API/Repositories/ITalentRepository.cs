using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;

namespace RecruitmentPortal.API.Repositories;

public interface ITalentRepository
{
    Task<int> AddNoteAsync(int candidateId, string note, int? createdBy);
    Task<IEnumerable<CandidateNote>> GetNotesAsync(int candidateId);

    Task<int> AddTagAsync(int candidateId, string tag, int? createdBy);
    Task<IEnumerable<CandidateTag>> GetTagsAsync(int candidateId);
    Task<bool> RemoveTagAsync(int id);
    Task<IEnumerable<string>> GetAllDistinctTagsAsync();

    Task<int> CreatePoolAsync(string name, string? description, int? createdBy);
    Task<IEnumerable<TalentPool>> GetPoolsAsync();
    Task<int> AddPoolMemberAsync(int poolId, int candidateId, int? addedBy);
    Task<bool> RemovePoolMemberAsync(int poolId, int candidateId);
    Task<IEnumerable<TalentPoolMember>> GetPoolMembersAsync(int poolId);
    Task<IEnumerable<TalentPoolSummary>> GetPoolsForCandidateAsync(int candidateId);

    Task<IEnumerable<CandidateSearchResult>> SearchAsync(CandidateSearchRequest request);

    Task<int> SaveSearchAsync(int userId, SavedSearchRequest request);
    Task<IEnumerable<SavedSearch>> GetSavedSearchesAsync(int userId);
    Task<bool> DeleteSavedSearchAsync(int id);
}
