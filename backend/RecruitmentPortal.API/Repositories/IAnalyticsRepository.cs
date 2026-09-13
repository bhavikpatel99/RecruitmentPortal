using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface IAnalyticsRepository
{
    Task<IEnumerable<TimeToFillRow>> GetTimeToFillAsync();
    Task<IEnumerable<TimeToHireRow>> GetTimeToHireAsync();
    Task<IEnumerable<SourceEffectivenessRow>> GetSourceEffectivenessAsync();
    Task<IEnumerable<StageFunnelRow>> GetStageFunnelAsync();
    Task<IEnumerable<RecruiterProductivityRow>> GetRecruiterProductivityAsync();
    Task<IEnumerable<InterviewTurnaroundRow>> GetInterviewTurnaroundAsync();
    Task<IEnumerable<OfferStatsRow>> GetOfferStatsAsync();
}
