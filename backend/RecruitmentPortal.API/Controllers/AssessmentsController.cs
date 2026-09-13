using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;
using RecruitmentPortal.API.Services;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Assessment templates and candidate invitations/results (spec module 15).</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class AssessmentsController : ControllerBase
{
    private readonly IAssessmentRepository _repository;
    private readonly ICandidateRepository _candidateRepository;
    private readonly IEmailService _emailService;

    public AssessmentsController(IAssessmentRepository repository, ICandidateRepository candidateRepository, IEmailService emailService)
    {
        _repository = repository;
        _candidateRepository = candidateRepository;
        _emailService = emailService;
    }

    [HttpGet("templates")]
    public async Task<ActionResult<IEnumerable<AssessmentTemplate>>> GetTemplates()
    {
        return Ok(await _repository.GetAllTemplatesAsync());
    }

    [HttpGet("templates/{id:int}")]
    public async Task<ActionResult<AssessmentTemplate>> GetTemplate(int id)
    {
        var template = await _repository.GetTemplateByIdAsync(id);
        return template is null ? NotFound() : Ok(template);
    }

    [HttpPost("templates")]
    public async Task<ActionResult<AssessmentTemplate>> CreateTemplate([FromBody] AssessmentTemplateRequest request)
    {
        var template = new AssessmentTemplate
        {
            Title = request.Title,
            AssessmentType = request.AssessmentType,
            Description = request.Description,
            VendorName = request.VendorName,
            ExternalLink = request.ExternalLink,
            PassingScore = request.PassingScore,
            DurationMinutes = request.DurationMinutes,
            CreatedBy = GetCurrentUserId()
        };
        template.Id = await _repository.CreateTemplateAsync(template);
        return CreatedAtAction(nameof(GetTemplate), new { id = template.Id }, template);
    }

    [HttpDelete("templates/{id:int}")]
    public async Task<IActionResult> DeleteTemplate(int id)
    {
        var deleted = await _repository.DeleteTemplateAsync(id);
        return deleted ? NoContent() : NotFound();
    }

    [HttpGet("invitations")]
    public async Task<ActionResult<IEnumerable<AssessmentInvitation>>> GetAllInvitations()
    {
        return Ok(await _repository.GetAllInvitationsAsync());
    }

    [HttpGet("candidates/{candidateId:int}/invitations")]
    public async Task<ActionResult<IEnumerable<AssessmentInvitation>>> GetInvitationsForCandidate(int candidateId)
    {
        return Ok(await _repository.GetInvitationsByCandidateIdAsync(candidateId));
    }

    /// <summary>Invite a candidate to an assessment; moves the candidate's pipeline stage to "Assessment".</summary>
    [HttpPost("invitations")]
    public async Task<IActionResult> Invite([FromBody] AssessmentInvitationRequest request)
    {
        var id = await _repository.CreateInvitationAsync(request.CandidateId, request.AssessmentTemplateId, GetCurrentUserId(), request.Deadline);

        var candidate = await _candidateRepository.GetByIdAsync(request.CandidateId);
        var template = await _repository.GetTemplateByIdAsync(request.AssessmentTemplateId);
        if (candidate is not null && template is not null)
        {
            await _emailService.SendTemplatedEmailAsync("AssessmentInvitation", candidate.Email, new Dictionary<string, string>
            {
                ["FirstName"] = candidate.FirstName,
                ["JobTitle"] = candidate.PositionApplied ?? "the role",
                ["AssessmentTitle"] = template.Title,
                ["Deadline"] = request.Deadline?.ToString("MMMM d, yyyy") ?? "the earliest opportunity",
                ["AssessmentLink"] = string.IsNullOrEmpty(template.ExternalLink) ? "" : $"<a href=\"{template.ExternalLink}\">Start assessment</a>"
            }, candidate.Id, GetCurrentUserId());
        }

        return Ok(new { id });
    }

    /// <summary>Record a result; pass/fail is computed against the template's passing score and automates the next pipeline stage.</summary>
    [HttpPost("invitations/{id:int}/result")]
    public async Task<IActionResult> RecordResult(int id, [FromBody] AssessmentResultRequest request)
    {
        var updated = await _repository.RecordResultAsync(id, request.Score, request.Notes, GetCurrentUserId());

        if (updated)
        {
            var invitation = await _repository.GetInvitationByIdAsync(id);
            if (invitation?.PassFail == "Fail")
            {
                var candidate = await _candidateRepository.GetByIdAsync(invitation.CandidateId);
                if (candidate is not null)
                {
                    await _emailService.SendTemplatedEmailAsync("RejectionNotice", candidate.Email, new Dictionary<string, string>
                    {
                        ["FirstName"] = candidate.FirstName,
                        ["JobTitle"] = candidate.PositionApplied ?? "the role",
                        ["ReasonNote"] = ""
                    }, candidate.Id, GetCurrentUserId());
                }
            }
        }

        return updated ? NoContent() : NotFound();
    }

    [HttpPost("invitations/{id:int}/status")]
    public async Task<IActionResult> UpdateStatus(int id, [FromBody] AssessmentStatusRequest request)
    {
        var updated = await _repository.UpdateStatusAsync(id, request.Status);
        return updated ? NoContent() : NotFound();
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }
}
