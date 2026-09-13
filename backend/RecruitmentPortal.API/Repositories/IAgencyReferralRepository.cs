using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface IAgencyReferralRepository
{
    // Agencies
    Task<int> CreateAgencyAsync(string name, string? contactEmail, string? contactPhone);
    Task<IEnumerable<Agency>> GetAgenciesAsync();
    Task<int> CreateAgencyUserAsync(int agencyId, string fullName, string email, string passwordHash);
    Task<IEnumerable<AgencyPerformance>> GetAgencyPerformanceAsync();

    // Agency submissions
    Task<AgencyDuplicateCheck?> CheckDuplicateAsync(string email);
    Task<int> CreateAgencySubmissionAsync(int agencyId, int? jobId, int? candidateId, int submittedBy, bool wasDuplicate, int? duplicateOfCandidateId);
    Task<IEnumerable<AgencySubmission>> GetSubmissionsByAgencyIdAsync(int agencyId);
    Task<IEnumerable<AgencySubmission>> GetAllSubmissionsAsync();

    // Referrals
    Task<(int Id, string ReferralCode)> CreateReferralLinkAsync(int referrerUserId, int jobId);
    Task<Referral?> GetReferralByCodeAsync(string referralCode);
    Task<Referral?> GetReferralByCandidateIdAsync(int candidateId);
    Task<bool> AttachCandidateToReferralAsync(string referralCode, int candidateId);
    Task<IEnumerable<Referral>> GetReferralsByReferrerAsync(int referrerUserId);
    Task<IEnumerable<Referral>> GetAllReferralsAsync();
    Task<bool> UpdateReferralBonusAsync(int id, decimal? bonusAmount, string bonusStatus);
}
