using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;
using RecruitmentPortal.API.Services;

namespace RecruitmentPortal.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize] // all candidate endpoints require a valid JWT
public class CandidatesController : ControllerBase
{
    private static readonly HashSet<string> AllowedResumeExtensions = new(StringComparer.OrdinalIgnoreCase)
    {
        ".pdf", ".doc", ".docx"
    };
    private const long MaxResumeSizeBytes = 5 * 1024 * 1024; // 5 MB

    private readonly ICandidateRepository _repository;
    private readonly IAgencyReferralRepository _agencyReferralRepository;
    private readonly IUserRepository _userRepository;
    private readonly IEmailService _emailService;
    private readonly IWebHostEnvironment _environment;
    private readonly ILogger<CandidatesController> _logger;

    public CandidatesController(
        ICandidateRepository repository,
        IAgencyReferralRepository agencyReferralRepository,
        IUserRepository userRepository,
        IEmailService emailService,
        IWebHostEnvironment environment,
        ILogger<CandidatesController> logger)
    {
        _repository = repository;
        _agencyReferralRepository = agencyReferralRepository;
        _userRepository = userRepository;
        _emailService = emailService;
        _environment = environment;
        _logger = logger;
    }

    /// <summary>
    /// Staff (Admin/Recruiter/HiringManager) get every candidate application, for the workspace
    /// pipeline/dashboard views. A candidate gets only their own applications.
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Candidate>>> GetAll()
    {
        if (IsStaff())
        {
            return Ok(await _repository.GetAllAsync());
        }

        var userId = GetCurrentUserId();
        if (userId is null)
            return Unauthorized();

        var candidates = await _repository.GetByUserIdAsync(userId.Value);
        return Ok(candidates);
    }

    /// <summary>Get candidate applications for a specific user.</summary>
    [HttpGet("user/{userId:int}")]
    public async Task<ActionResult<IEnumerable<Candidate>>> GetByUserId(int userId)
    {
        var currentUserId = GetCurrentUserId();
        if (currentUserId != userId)
            return Forbid("You can only view your own candidates.");

        var candidates = await _repository.GetByUserIdAsync(userId);
        return Ok(candidates);
    }

    /// <summary>Get a single candidate by id. Staff can view any candidate; a candidate can only view their own record.</summary>
    [HttpGet("{id:int}")]
    public async Task<ActionResult<Candidate>> GetById(int id)
    {
        var candidate = await _repository.GetByIdAsync(id);
        if (candidate is null)
            return NotFound();

        if (!IsStaff() && candidate.UserId != GetCurrentUserId())
            return Forbid();

        return Ok(candidate);
    }

    /// <summary>Submit a new candidate application form.</summary>
    [HttpPost]
    public async Task<ActionResult<Candidate>> Create([FromBody] CandidateRequest request)
    {
        try
        {
            var candidate = MapToEntity(request);
            candidate.UserId = GetCurrentUserId();
            candidate.Status = "Applied";

            Referral? referral = null;
            if (!string.IsNullOrWhiteSpace(request.ReferralCode))
            {
                referral = await _agencyReferralRepository.GetReferralByCodeAsync(request.ReferralCode);
                if (referral is not null)
                {
                    candidate.Source = "Referral";
                    candidate.JobId ??= referral.JobId;
                }
            }

            _logger.LogInformation("Creating candidate: {FirstName} {LastName}, UserId: {UserId}",
                candidate.FirstName, candidate.LastName, candidate.UserId);

            candidate.Id = await _repository.CreateAsync(candidate);

            _logger.LogInformation("Candidate created successfully with Id: {Id}", candidate.Id);

            await _emailService.SendTemplatedEmailAsync("ApplicationReceived", candidate.Email, new Dictionary<string, string>
            {
                ["FirstName"] = candidate.FirstName,
                ["JobTitle"] = candidate.PositionApplied ?? "the role"
            }, candidate.Id);

            if (referral is not null)
            {
                await _agencyReferralRepository.AttachCandidateToReferralAsync(referral.ReferralCode, candidate.Id);

                var referrer = await _userRepository.GetByIdAsync(referral.ReferrerUserId);
                if (referrer is not null)
                {
                    await _emailService.SendTemplatedEmailAsync("ReferralInvite", referrer.Email, new Dictionary<string, string>
                    {
                        ["ReferrerName"] = referrer.FullName,
                        ["CandidateName"] = $"{candidate.FirstName} {candidate.LastName}",
                        ["JobTitle"] = candidate.PositionApplied ?? "the role"
                    }, candidate.Id);
                }
            }

            return CreatedAtAction(nameof(GetById), new { id = candidate.Id }, candidate);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to create candidate");
            return BadRequest(new { message = "Failed to create candidate. Please check the submitted details and try again." });
        }
    }

    /// <summary>Update an existing candidate application.</summary>
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] CandidateRequest request)
    {
        try
        {
            var existing = await _repository.GetByIdAsync(id);
            if (existing is null)
            {
                _logger.LogWarning("Candidate {Id} not found for update", id);
                return NotFound();
            }

            if (!IsStaff() && existing.UserId != GetCurrentUserId())
                return Forbid();

            var candidate = MapToEntity(request);
            candidate.Id = id;
            candidate.UserId = existing.UserId;
            candidate.Status = existing.Status;

            _logger.LogInformation("Updating candidate {Id}: {FirstName} {LastName}",
                id, candidate.FirstName, candidate.LastName);

            var updated = await _repository.UpdateAsync(candidate);

            if (updated)
            {
                _logger.LogInformation("Candidate {Id} updated successfully", id);
                return NoContent();
            }

            _logger.LogError("Failed to update candidate {Id} - no rows affected", id);
            return BadRequest(new { message = "Failed to update candidate - no rows affected." });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to update candidate {Id}", id);
            return BadRequest(new { message = "Failed to update candidate. Please check the submitted details and try again." });
        }
    }

    /// <summary>Delete (withdraw) a candidate application. Staff can delete any; a candidate can only withdraw their own.</summary>
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var existing = await _repository.GetByIdAsync(id);
        if (existing is null)
            return NotFound();

        if (!IsStaff() && existing.UserId != GetCurrentUserId())
            return Forbid();

        var deleted = await _repository.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }

    /// <summary>
    /// Upload (or replace) a candidate's resume file. Staff can upload for any
    /// candidate; a candidate can only upload their own. Stored under wwwroot so
    /// it's reachable as a plain URL - the same way a pasted external resume link
    /// already worked - and kept under a per-candidate, GUID-named path so a
    /// future AI resume-parsing/matching feature has a stable, direct file to read.
    /// </summary>
    [HttpPost("{id:int}/resume")]
    [RequestSizeLimit(MaxResumeSizeBytes + 1024)]
    public async Task<IActionResult> UploadResume(int id, IFormFile file)
    {
        var existing = await _repository.GetByIdAsync(id);
        if (existing is null)
            return NotFound();

        if (!IsStaff() && existing.UserId != GetCurrentUserId())
            return Forbid();

        if (file is null || file.Length == 0)
            return BadRequest(new { message = "No file was uploaded." });

        if (file.Length > MaxResumeSizeBytes)
            return BadRequest(new { message = "Resume file must be 5 MB or smaller." });

        var extension = Path.GetExtension(file.FileName);
        if (string.IsNullOrEmpty(extension) || !AllowedResumeExtensions.Contains(extension))
            return BadRequest(new { message = "Resume must be a PDF, DOC, or DOCX file." });

        var webRoot = _environment.WebRootPath ?? Path.Combine(_environment.ContentRootPath, "wwwroot");
        var candidateFolder = Path.Combine(webRoot, "uploads", "resumes", id.ToString());
        Directory.CreateDirectory(candidateFolder);

        var storedFileName = $"{Guid.NewGuid()}{extension}";
        var fullPath = Path.Combine(candidateFolder, storedFileName);

        using (var stream = new FileStream(fullPath, FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }

        var resumeUrl = $"/uploads/resumes/{id}/{storedFileName}";
        var originalFileName = Path.GetFileName(file.FileName);

        await _repository.UpdateResumeAsync(id, resumeUrl, originalFileName);

        _logger.LogInformation("Resume uploaded for candidate {Id}: {FileName}", id, originalFileName);

        return Ok(new { resumeUrl, resumeFileName = originalFileName });
    }

    /// <summary>Move a candidate to a new recruitment-pipeline stage (e.g. Screening, Shortlisted, Interview, Offer, Hired, Rejected).</summary>
    [HttpPatch("{id:int}/stage")]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<IActionResult> ChangeStage(int id, [FromBody] ChangeStageRequest request)
    {
        var changedBy = GetCurrentUserId();

        _logger.LogInformation("Moving candidate {Id} to stage {NewStatus}", id, request.NewStatus);

        var updated = await _repository.ChangeStageAsync(id, request.NewStatus, changedBy, request.Reason, request.Notes);

        if (updated && request.NewStatus == "Rejected")
        {
            var candidate = await _repository.GetByIdAsync(id);
            if (candidate is not null)
            {
                await _emailService.SendTemplatedEmailAsync("RejectionNotice", candidate.Email, new Dictionary<string, string>
                {
                    ["FirstName"] = candidate.FirstName,
                    ["JobTitle"] = candidate.PositionApplied ?? "the role",
                    ["ReasonNote"] = string.IsNullOrWhiteSpace(request.Reason) ? "" : request.Reason
                }, candidate.Id, changedBy);
            }
        }
        else if (updated && request.NewStatus == "Hired")
        {
            // A referral that results in a hire becomes eligible for its bonus.
            var referral = await _agencyReferralRepository.GetReferralByCandidateIdAsync(id);
            if (referral is not null && referral.BonusStatus == "NotEligible")
            {
                await _agencyReferralRepository.UpdateReferralBonusAsync(referral.Id, referral.BonusAmount, "Pending");
            }
        }

        return updated ? NoContent() : NotFound();
    }

    /// <summary>Get the pipeline stage-change history for a candidate. Staff can view any candidate's history; a candidate can only view their own (it includes internal recruiter notes/rejection reasons).</summary>
    [HttpGet("{id:int}/stage-history")]
    public async Task<ActionResult<IEnumerable<CandidateStageHistory>>> GetStageHistory(int id)
    {
        if (!IsStaff())
        {
            var candidate = await _repository.GetByIdAsync(id);
            if (candidate is null)
                return NotFound();
            if (candidate.UserId != GetCurrentUserId())
                return Forbid();
        }

        var history = await _repository.GetStageHistoryAsync(id);
        return Ok(history);
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }

    private bool IsStaff() => User.IsInRole("Admin") || User.IsInRole("Recruiter") || User.IsInRole("HiringManager");

    private static Candidate MapToEntity(CandidateRequest r) => new()
    {
        FirstName = r.FirstName,
        MiddleName = r.MiddleName,
        LastName = r.LastName,
        Email = r.Email,
        Phone = r.Phone,
        AlternatePhone = r.AlternatePhone,
        DateOfBirth = r.DateOfBirth,
        Gender = r.Gender,
        MaritalStatus = r.MaritalStatus,
        Nationality = r.Nationality,
        Address = r.Address,
        City = r.City,
        State = r.State,
        Country = r.Country,
        PostalCode = r.PostalCode,
        PositionApplied = r.PositionApplied,
        EmploymentType = r.EmploymentType,
        TotalExperience = r.TotalExperience,
        CurrentCompany = r.CurrentCompany,
        CurrentCtc = r.CurrentCtc,
        ExpectedCtc = r.ExpectedCtc,
        NoticePeriodDays = r.NoticePeriodDays,
        PreferredLocation = r.PreferredLocation,
        WillingToRelocate = r.WillingToRelocate,
        AvailableFrom = r.AvailableFrom,
        HighestQualification = r.HighestQualification,
        Skills = r.Skills,
        LinkedInUrl = r.LinkedInUrl,
        PortfolioUrl = r.PortfolioUrl,
        GitHubUrl = r.GitHubUrl,
        ResumeUrl = r.ResumeUrl,
        CoverLetter = r.CoverLetter,
        ReferenceName = r.ReferenceName,
        ReferenceContact = r.ReferenceContact,
        Source = r.Source
    };
}
