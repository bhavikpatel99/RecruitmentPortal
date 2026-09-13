using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface IOrgSetupRepository
{
    Task<IEnumerable<Department>> GetDepartmentsAsync();
    Task<int> CreateDepartmentAsync(string name);
    Task<bool> DeleteDepartmentAsync(int id);

    Task<IEnumerable<OfficeLocation>> GetLocationsAsync();
    Task<int> CreateLocationAsync(string name, string? city, string? country);
    Task<bool> DeleteLocationAsync(int id);

    Task<IEnumerable<JobFamily>> GetJobFamiliesAsync();
    Task<int> CreateJobFamilyAsync(string name, string? description);
    Task<bool> DeleteJobFamilyAsync(int id);

    Task<IEnumerable<SkillMaster>> GetSkillsAsync();
    Task<int> CreateSkillAsync(string name, string? category);
    Task<bool> DeleteSkillAsync(int id);

    Task<IEnumerable<Competency>> GetCompetenciesAsync();
    Task<int> CreateCompetencyAsync(string name, string? description);
    Task<bool> DeleteCompetencyAsync(int id);

    Task<IEnumerable<SalaryBand>> GetSalaryBandsAsync();
    Task<int> CreateSalaryBandAsync(int? jobFamilyId, string level, decimal minSalary, decimal maxSalary, string currency);
    Task<bool> DeleteSalaryBandAsync(int id);

    Task<IEnumerable<ApprovalMatrix>> GetApprovalMatricesAsync();
    Task<int> CreateApprovalMatrixAsync(string name, string? description, decimal? minAmount, decimal? maxAmount, string requiredApproverRole);
    Task<bool> DeleteApprovalMatrixAsync(int id);

    Task<IEnumerable<InterviewPanelMaster>> GetInterviewPanelsAsync();
    Task<int> CreateInterviewPanelAsync(string name, string? description, int? createdBy);
    Task<bool> DeleteInterviewPanelAsync(int id);
    Task<IEnumerable<InterviewPanelMasterMember>> GetInterviewPanelMembersAsync(int panelId);
    Task AddInterviewPanelMemberAsync(int panelId, int userId);
    Task<bool> RemoveInterviewPanelMemberAsync(int panelId, int userId);
}
