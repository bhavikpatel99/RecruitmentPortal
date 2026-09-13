using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Recruitment Analytics (spec module 25): time-to-fill, time-to-hire, source effectiveness,
/// stage funnel, recruiter productivity, interview turnaround, offer acceptance. Cost-per-hire and
/// diversity metrics are intentionally omitted - this system doesn't collect the budget-actuals or
/// protected-characteristic data those would require.</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class AnalyticsController : ControllerBase
{
    private readonly IAnalyticsRepository _repository;

    public AnalyticsController(IAnalyticsRepository repository)
    {
        _repository = repository;
    }

    [HttpGet("time-to-fill")]
    public async Task<ActionResult<IEnumerable<TimeToFillRow>>> GetTimeToFill() => Ok(await _repository.GetTimeToFillAsync());

    [HttpGet("time-to-hire")]
    public async Task<ActionResult<IEnumerable<TimeToHireRow>>> GetTimeToHire() => Ok(await _repository.GetTimeToHireAsync());

    [HttpGet("source-effectiveness")]
    public async Task<ActionResult<IEnumerable<SourceEffectivenessRow>>> GetSourceEffectiveness() => Ok(await _repository.GetSourceEffectivenessAsync());

    [HttpGet("stage-funnel")]
    public async Task<ActionResult<IEnumerable<StageFunnelRow>>> GetStageFunnel() => Ok(await _repository.GetStageFunnelAsync());

    [HttpGet("recruiter-productivity")]
    public async Task<ActionResult<IEnumerable<RecruiterProductivityRow>>> GetRecruiterProductivity() => Ok(await _repository.GetRecruiterProductivityAsync());

    [HttpGet("interview-turnaround")]
    public async Task<ActionResult<IEnumerable<InterviewTurnaroundRow>>> GetInterviewTurnaround() => Ok(await _repository.GetInterviewTurnaroundAsync());

    [HttpGet("offer-stats")]
    public async Task<ActionResult<IEnumerable<OfferStatsRow>>> GetOfferStats() => Ok(await _repository.GetOfferStatsAsync());
}
