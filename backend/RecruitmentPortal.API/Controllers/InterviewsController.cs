using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;
using RecruitmentPortal.API.Services;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Interview scheduling, panel management, reschedule/cancel and structured scorecards (spec module 14).</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize]
public class InterviewsController : ControllerBase
{
    private readonly IInterviewRepository _repository;
    private readonly ICandidateRepository _candidateRepository;
    private readonly IEmailService _emailService;
    private readonly ILogger<InterviewsController> _logger;

    public InterviewsController(IInterviewRepository repository, ICandidateRepository candidateRepository, IEmailService emailService, ILogger<InterviewsController> logger)
    {
        _repository = repository;
        _candidateRepository = candidateRepository;
        _emailService = emailService;
        _logger = logger;
    }

    /// <summary>List all interviews (recruiter workspace list view).</summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Interview>>> GetAll()
    {
        return Ok(await _repository.GetAllAsync());
    }

    /// <summary>List interviews for a candidate.</summary>
    [HttpGet("candidate/{candidateId:int}")]
    public async Task<ActionResult<IEnumerable<Interview>>> GetByCandidate(int candidateId)
    {
        return Ok(await _repository.GetByCandidateIdAsync(candidateId));
    }

    /// <summary>Get a single interview by id.</summary>
    [HttpGet("{id:int}")]
    public async Task<ActionResult<Interview>> GetById(int id)
    {
        var interview = await _repository.GetByIdAsync(id);
        return interview is null ? NotFound() : Ok(interview);
    }

    /// <summary>List upcoming scheduled interviews from now (or a given date).</summary>
    [HttpGet("upcoming")]
    public async Task<ActionResult<IEnumerable<Interview>>> GetUpcoming([FromQuery] DateTime? fromDate)
    {
        return Ok(await _repository.GetUpcomingAsync(fromDate ?? DateTime.UtcNow));
    }

    /// <summary>Get the interview panel for an interview.</summary>
    [HttpGet("{id:int}/panelists")]
    public async Task<ActionResult<IEnumerable<InterviewPanelist>>> GetPanelists(int id)
    {
        return Ok(await _repository.GetPanelistsAsync(id));
    }

    /// <summary>Get submitted scorecards for an interview.</summary>
    [HttpGet("{id:int}/feedback")]
    public async Task<ActionResult<IEnumerable<InterviewFeedback>>> GetFeedback(int id)
    {
        return Ok(await _repository.GetFeedbackAsync(id));
    }

    /// <summary>Schedule a new interview and invite the panel.</summary>
    [HttpPost]
    [Authorize(Roles = "Admin,Recruiter,HiringManager")]
    public async Task<ActionResult<Interview>> Schedule([FromBody] ScheduleInterviewRequest request)
    {
        try
        {
            var interview = new Interview
            {
                CandidateId = request.CandidateId,
                JobId = request.JobId,
                RoundNumber = request.RoundNumber,
                InterviewType = request.InterviewType,
                ScheduledAt = request.ScheduledAt,
                DurationMinutes = request.DurationMinutes,
                Mode = request.Mode,
                MeetingLink = request.MeetingLink,
                Location = request.Location,
                ScheduledBy = GetCurrentUserId()
            };

            _logger.LogInformation("Scheduling interview for candidate {CandidateId}, round {RoundNumber}",
                interview.CandidateId, interview.RoundNumber);

            interview.Id = await _repository.CreateAsync(interview);

            foreach (var panelistId in request.PanelistIds.Distinct())
            {
                await _repository.AddPanelistAsync(interview.Id, panelistId, panelistId == request.LeadInterviewerId);
            }

            var candidate = await _candidateRepository.GetByIdAsync(interview.CandidateId);
            if (candidate is not null)
            {
                var meetingInfo = !string.IsNullOrEmpty(interview.MeetingLink)
                    ? $"<a href=\"{interview.MeetingLink}\">Join the interview</a>"
                    : !string.IsNullOrEmpty(interview.Location) ? $"Location: {interview.Location}" : "";

                await _emailService.SendTemplatedEmailAsync("InterviewScheduled", candidate.Email, new Dictionary<string, string>
                {
                    ["FirstName"] = candidate.FirstName,
                    ["JobTitle"] = candidate.PositionApplied ?? "the role",
                    ["InterviewType"] = interview.InterviewType ?? "interview",
                    ["ScheduledAt"] = interview.ScheduledAt?.ToString("MMMM d, yyyy 'at' h:mm tt") ?? "a time to be confirmed",
                    ["MeetingInfo"] = meetingInfo
                }, candidate.Id, GetCurrentUserId());
            }

            return CreatedAtAction(nameof(GetById), new { id = interview.Id }, interview);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to schedule interview");
            return BadRequest(new { message = "Failed to schedule interview. Please check the submitted details and try again." });
        }
    }

    /// <summary>Reschedule an interview.</summary>
    [HttpPost("{id:int}/reschedule")]
    [Authorize(Roles = "Admin,Recruiter,HiringManager")]
    public async Task<IActionResult> Reschedule(int id, [FromBody] RescheduleInterviewRequest request)
    {
        var updated = await _repository.RescheduleAsync(id, request.ScheduledAt, request.DurationMinutes, request.Mode, request.MeetingLink, request.Location);
        return updated ? NoContent() : NotFound();
    }

    /// <summary>Cancel, complete, or mark an interview as no-show.</summary>
    [HttpPost("{id:int}/status")]
    [Authorize(Roles = "Admin,Recruiter,HiringManager")]
    public async Task<IActionResult> UpdateStatus(int id, [FromBody] InterviewStatusRequest request)
    {
        var updated = await _repository.UpdateStatusAsync(id, request.Status, request.CancellationReason);
        return updated ? NoContent() : NotFound();
    }

    /// <summary>Add a panelist to an interview.</summary>
    [HttpPost("{id:int}/panelists/{interviewerId:int}")]
    [Authorize(Roles = "Admin,Recruiter,HiringManager")]
    public async Task<IActionResult> AddPanelist(int id, int interviewerId, [FromQuery] bool isLead = false)
    {
        await _repository.AddPanelistAsync(id, interviewerId, isLead);
        return NoContent();
    }

    /// <summary>Remove a panelist from an interview.</summary>
    [HttpDelete("{id:int}/panelists/{interviewerId:int}")]
    [Authorize(Roles = "Admin,Recruiter,HiringManager")]
    public async Task<IActionResult> RemovePanelist(int id, int interviewerId)
    {
        var removed = await _repository.RemovePanelistAsync(id, interviewerId);
        return removed ? NoContent() : NotFound();
    }

    /// <summary>Submit (or update) the current interviewer's structured scorecard for an interview.</summary>
    [HttpPost("{id:int}/feedback")]
    public async Task<IActionResult> SubmitFeedback(int id, [FromBody] InterviewFeedbackRequest request)
    {
        var interviewerId = GetCurrentUserId();
        if (interviewerId is null)
            return Unauthorized();

        await _repository.SubmitFeedbackAsync(id, interviewerId.Value, request.Rating, request.Recommendation,
            request.Strengths, request.Concerns, request.Comments);

        return NoContent();
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }
}
