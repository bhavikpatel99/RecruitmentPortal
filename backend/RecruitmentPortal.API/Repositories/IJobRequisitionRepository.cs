using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface IJobRequisitionRepository
{
    Task<IEnumerable<JobRequisition>> GetAllAsync();
    Task<JobRequisition?> GetByIdAsync(int id);
    Task<int> CreateAsync(JobRequisition requisition);
    Task<bool> UpdateAsync(JobRequisition requisition);
    Task<bool> UpdateStatusAsync(int id, string newStatus, int? performedBy, string? rejectionReason, string? notes);
    Task<bool> LinkJobAsync(int id, int jobId);
    Task<IEnumerable<JobRequisitionAudit>> GetAuditAsync(int jobRequisitionId);
    Task<bool> DeleteAsync(int id);
}
