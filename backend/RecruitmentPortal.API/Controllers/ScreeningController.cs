using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;
using RecruitmentPortal.API.Services;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Structured screening forms, knockout questions, and shortlist/reject scorecards (spec module 13).</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class ScreeningController : ControllerBase
{
    private readonly IScreeningRepository _repository;
    private readonly ICandidateRepository _candidateRepository;
    private readonly IEmailService _emailService;

    public ScreeningController(IScreeningRepository repository, ICandidateRepository candidateRepository, IEmailService emailService)
    {
        _repository = repository;
        _candidateRepository = candidateRepository;
        _emailService = emailService;
    }

    [HttpGet("forms")]
    public async Task<ActionResult<IEnumerable<ScreeningForm>>> GetForms()
    {
        return Ok(await _repository.GetAllFormsAsync());
    }

    [HttpGet("forms/{id:int}")]
    public async Task<ActionResult<ScreeningForm>> GetForm(int id)
    {
        var form = await _repository.GetFormByIdAsync(id);
        return form is null ? NotFound() : Ok(form);
    }

    [HttpGet("forms/{id:int}/questions")]
    public async Task<ActionResult<IEnumerable<ScreeningQuestion>>> GetQuestions(int id)
    {
        return Ok(await _repository.GetQuestionsByFormIdAsync(id));
    }

    [HttpPost("forms")]
    public async Task<ActionResult<ScreeningForm>> CreateForm([FromBody] ScreeningFormRequest request)
    {
        var form = new ScreeningForm { JobId = request.JobId, Title = request.Title, Description = request.Description, CreatedBy = GetCurrentUserId() };
        form.Id = await _repository.CreateFormAsync(form);
        return CreatedAtAction(nameof(GetForm), new { id = form.Id }, form);
    }

    [HttpPost("forms/{id:int}/questions")]
    public async Task<IActionResult> AddQuestion(int id, [FromBody] ScreeningQuestionRequest request)
    {
        var questionId = await _repository.AddQuestionAsync(id, request);
        return Ok(new { id = questionId });
    }

    [HttpDelete("questions/{id:int}")]
    public async Task<IActionResult> DeleteQuestion(int id)
    {
        var deleted = await _repository.DeleteQuestionAsync(id);
        return deleted ? NoContent() : NotFound();
    }

    /// <summary>Submit a candidate's screening responses; knockout questions are auto-evaluated.</summary>
    [HttpPost("responses")]
    public async Task<IActionResult> SubmitResponse([FromBody] ScreeningResponseSubmitRequest request)
    {
        var id = await _repository.SubmitResponseAsync(request.CandidateId, request.ScreeningFormId, GetCurrentUserId(), request.RecruiterNotes, request.Answers);
        return Ok(new { id });
    }

    [HttpGet("candidates/{candidateId:int}/responses")]
    public async Task<ActionResult<IEnumerable<ScreeningResponse>>> GetResponses(int candidateId)
    {
        return Ok(await _repository.GetResponsesByCandidateIdAsync(candidateId));
    }

    [HttpGet("responses/{id:int}/answers")]
    public async Task<ActionResult<IEnumerable<ScreeningAnswer>>> GetAnswers(int id)
    {
        return Ok(await _repository.GetAnswersAsync(id));
    }

    /// <summary>Recruiter's final shortlist/reject/hold decision after reviewing a screening response.</summary>
    [HttpPost("responses/{id:int}/recommendation")]
    public async Task<IActionResult> UpdateRecommendation(int id, [FromBody] ScreeningRecommendationRequest request)
    {
        var updated = await _repository.UpdateRecommendationAsync(id, request.Recommendation, request.OverallScore, request.RecruiterNotes, GetCurrentUserId());

        if (updated && request.Recommendation == "Reject")
        {
            var response = await _repository.GetResponseByIdAsync(id);
            var candidate = response is not null ? await _candidateRepository.GetByIdAsync(response.CandidateId) : null;
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

        return updated ? NoContent() : NotFound();
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }
}
