using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface IPreJoiningRepository
{
    Task<IEnumerable<PreJoiningChecklist>> GetByCandidateIdAsync(int candidateId);
    Task<IEnumerable<PreJoiningTask>> GetTasksAsync(int checklistId);
    Task<bool> SetJoiningDateAsync(int checklistId, DateTime joiningDate);
    Task<bool> UpdateBgvStatusAsync(int checklistId, string bgvStatus);
    Task<int> AddTaskAsync(int checklistId, string taskName, int sortOrder);
    Task<bool> ToggleTaskAsync(int id, bool isCompleted);

    Task<IEnumerable<HireEvent>> GetHireEventsByCandidateIdAsync(int candidateId);
    Task<IEnumerable<HireEvent>> GetAllHireEventsAsync();
    Task<bool> MarkHireEventSentAsync(int id);
}
