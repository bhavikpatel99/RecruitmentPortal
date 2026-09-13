using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface IJobRepository
{
    Task<IEnumerable<Job>> GetAllAsync();
    Task<Job?> GetByIdAsync(int id);
    Task<IEnumerable<Job>> GetOpenJobsAsync();
    Task<int> CreateAsync(Job job);
    Task<bool> UpdateAsync(Job job);
    Task<bool> DeleteAsync(int id);

    Task<int> AddPostingChannelAsync(int jobId, string channel, string? externalUrl, DateTime? expiryDate, int? createdBy);
    Task<IEnumerable<JobPostingChannel>> GetPostingChannelsAsync(int jobId);
    Task<bool> UpdatePostingChannelStatusAsync(int id, string status);
}
