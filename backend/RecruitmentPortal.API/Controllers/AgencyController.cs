using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;
using RecruitmentPortal.API.Services;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Agency/Vendor Portal (spec module 18): agency accounts and duplicate-protected candidate submissions.</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AgencyController : ControllerBase
{
    private readonly IAgencyReferralRepository _repository;
    private readonly ICandidateRepository _candidateRepository;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IEmailService _emailService;

    public AgencyController(
        IAgencyReferralRepository repository,
        ICandidateRepository candidateRepository,
        IPasswordHasher passwordHasher,
        IEmailService emailService)
    {
        _repository = repository;
        _candidateRepository = candidateRepository;
        _passwordHasher = passwordHasher;
        _emailService = emailService;
    }

    [HttpGet]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<ActionResult<IEnumerable<Agency>>> GetAll() => Ok(await _repository.GetAgenciesAsync());

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Create([FromBody] AgencyRequest request)
    {
        var id = await _repository.CreateAgencyAsync(request.Name, request.ContactEmail, request.ContactPhone);
        return Ok(new { id });
    }

    [HttpPost("users")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> CreateAgencyUser([FromBody] AgencyUserRequest request)
    {
        var hash = _passwordHasher.Hash(request.Password);
        var id = await _repository.CreateAgencyUserAsync(request.AgencyId, request.FullName, request.Email, hash);
        return Ok(new { id });
    }

    [HttpGet("performance")]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<ActionResult<IEnumerable<AgencyPerformance>>> GetPerformance() => Ok(await _repository.GetAgencyPerformanceAsync());

    [HttpGet("submissions")]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<ActionResult<IEnumerable<AgencySubmission>>> GetAllSubmissions() => Ok(await _repository.GetAllSubmissionsAsync());

    [HttpGet("submissions/mine")]
    [Authorize(Roles = "Agency")]
    public async Task<ActionResult<IEnumerable<AgencySubmission>>> GetMySubmissions()
    {
        var agencyId = GetAgencyId();
        if (agencyId is null) return Forbid();
        return Ok(await _repository.GetSubmissionsByAgencyIdAsync(agencyId.Value));
    }

    /// <summary>Submit a candidate on behalf of the agency. If the email already exists, the submission is
    /// recorded as a duplicate (for performance reporting) and no new candidate record is created - the
    /// original submitter keeps ownership.</summary>
    [HttpPost("submissions")]
    [Authorize(Roles = "Agency")]
    public async Task<IActionResult> Submit([FromBody] AgencySubmissionRequest request)
    {
        var agencyId = GetAgencyId();
        var userId = GetCurrentUserId();
        if (agencyId is null || userId is null) return Forbid();

        var duplicate = await _repository.CheckDuplicateAsync(request.Email);
        if (duplicate is not null)
        {
            await _repository.CreateAgencySubmissionAsync(agencyId.Value, request.JobId, null, userId.Value, true, duplicate.Id);
            return Conflict(new { message = $"A candidate with this email already exists (source: {duplicate.Source}). Submission recorded as a duplicate; ownership remains with the original submitter." });
        }

        var candidate = new Candidate
        {
            JobId = request.JobId,
            FirstName = request.FirstName,
            MiddleName = request.MiddleName,
            LastName = request.LastName,
            Email = request.Email,
            Phone = request.Phone,
            AlternatePhone = request.AlternatePhone,
            DateOfBirth = request.DateOfBirth,
            Gender = request.Gender,
            MaritalStatus = request.MaritalStatus,
            Nationality = request.Nationality,
            Address = request.Address,
            City = request.City,
            State = request.State,
            Country = request.Country,
            PostalCode = request.PostalCode,
            PositionApplied = request.PositionApplied,
            EmploymentType = request.EmploymentType,
            TotalExperience = request.TotalExperience,
            CurrentCompany = request.CurrentCompany,
            CurrentCtc = request.CurrentCtc,
            ExpectedCtc = request.ExpectedCtc,
            NoticePeriodDays = request.NoticePeriodDays,
            PreferredLocation = request.PreferredLocation,
            WillingToRelocate = request.WillingToRelocate,
            AvailableFrom = request.AvailableFrom,
            HighestQualification = request.HighestQualification,
            Skills = request.Skills,
            LinkedInUrl = request.LinkedInUrl,
            PortfolioUrl = request.PortfolioUrl,
            GitHubUrl = request.GitHubUrl,
            ResumeUrl = request.ResumeUrl,
            CoverLetter = request.CoverLetter,
            ReferenceName = request.ReferenceName,
            ReferenceContact = request.ReferenceContact,
            Source = "Agency",
            Status = "Applied"
        };
        candidate.Id = await _candidateRepository.CreateAsync(candidate);

        await _repository.CreateAgencySubmissionAsync(agencyId.Value, request.JobId, candidate.Id, userId.Value, false, null);

        await _emailService.SendTemplatedEmailAsync("ApplicationReceived", candidate.Email, new Dictionary<string, string>
        {
            ["FirstName"] = candidate.FirstName,
            ["JobTitle"] = candidate.PositionApplied ?? "the role"
        }, candidate.Id);

        return Ok(new { candidateId = candidate.Id });
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }

    private int? GetAgencyId()
    {
        var value = User.FindFirstValue("AgencyId");
        return int.TryParse(value, out var id) ? id : null;
    }
}
