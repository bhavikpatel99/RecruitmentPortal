using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;
using RecruitmentPortal.API.Services;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Communication Center (spec module 20): SMTP configuration, email templates, manual sends, and the audit log.</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class CommunicationController : ControllerBase
{
    private readonly ICommunicationRepository _repository;
    private readonly ICandidateRepository _candidateRepository;
    private readonly IEmailSender _emailSender;
    private readonly IEmailService _emailService;
    private readonly ISmtpPasswordProtector _passwordProtector;

    public CommunicationController(
        ICommunicationRepository repository,
        ICandidateRepository candidateRepository,
        IEmailSender emailSender,
        IEmailService emailService,
        ISmtpPasswordProtector passwordProtector)
    {
        _repository = repository;
        _candidateRepository = candidateRepository;
        _emailSender = emailSender;
        _emailService = emailService;
        _passwordProtector = passwordProtector;
    }

    // ---- SMTP settings (Admin only - sensitive) ----
    [HttpGet("smtp-settings")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<SmtpSettingsDto>> GetSmtpSettings()
    {
        var settings = await _repository.GetActiveSmtpSettingsAsync();
        if (settings is null) return Ok(null);

        return Ok(new SmtpSettingsDto
        {
            Id = settings.Id,
            Provider = settings.Provider,
            Host = settings.Host,
            Port = settings.Port,
            SecureSocketMode = settings.SecureSocketMode,
            Username = settings.Username,
            FromEmail = settings.FromEmail,
            FromName = settings.FromName,
            IsActive = settings.IsActive,
            CreatedAt = settings.CreatedAt,
            HasPassword = !string.IsNullOrEmpty(settings.EncryptedPassword)
        });
    }

    [HttpPost("smtp-settings")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> SaveSmtpSettings([FromBody] SmtpSettingsRequest request)
    {
        var existing = await _repository.GetActiveSmtpSettingsAsync();
        var encryptedPassword = !string.IsNullOrEmpty(request.Password)
            ? _passwordProtector.Protect(request.Password)
            : existing?.EncryptedPassword;

        if (string.IsNullOrEmpty(encryptedPassword))
            return BadRequest(new { message = "A password is required the first time SMTP is configured." });

        var settings = new SmtpSettings
        {
            Provider = request.Provider,
            Host = request.Host,
            Port = request.Port,
            SecureSocketMode = request.SecureSocketMode,
            Username = request.Username,
            EncryptedPassword = encryptedPassword,
            FromEmail = request.FromEmail,
            FromName = request.FromName,
            CreatedBy = GetCurrentUserId()
        };

        var id = await _repository.UpsertSmtpSettingsAsync(settings);
        return Ok(new { id });
    }

    [HttpPost("smtp-settings/test")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> SendTestEmail([FromBody] SendTestEmailRequest request)
    {
        var result = await _emailSender.SendAsync(request.ToEmail, "Recruitment Portal - Test Email",
            "<p>This is a test email confirming your SMTP configuration works.</p>");

        return result.Success ? Ok(new { message = "Test email sent successfully." }) : BadRequest(new { message = result.ErrorMessage });
    }

    // ---- Templates ----
    [HttpGet("templates")]
    public async Task<ActionResult<IEnumerable<EmailTemplate>>> GetTemplates()
    {
        return Ok(await _repository.GetAllTemplatesAsync());
    }

    [HttpGet("templates/{id:int}")]
    public async Task<ActionResult<EmailTemplate>> GetTemplate(int id)
    {
        var template = await _repository.GetTemplateByIdAsync(id);
        return template is null ? NotFound() : Ok(template);
    }

    [HttpPost("templates")]
    public async Task<IActionResult> CreateTemplate([FromBody] EmailTemplateRequest request)
    {
        var code = string.IsNullOrWhiteSpace(request.Code)
            ? request.Name.Replace(" ", "") + Guid.NewGuid().ToString("N")[..6]
            : request.Code;

        var template = new EmailTemplate
        {
            Code = code,
            Name = request.Name,
            Subject = request.Subject,
            BodyHtml = request.BodyHtml,
            Category = request.Category,
            IsSystem = false,
            CreatedBy = GetCurrentUserId()
        };
        template.Id = await _repository.CreateTemplateAsync(template);
        return CreatedAtAction(nameof(GetTemplate), new { id = template.Id }, template);
    }

    [HttpPut("templates/{id:int}")]
    public async Task<IActionResult> UpdateTemplate(int id, [FromBody] EmailTemplateRequest request)
    {
        var template = new EmailTemplate
        {
            Id = id,
            Name = request.Name,
            Subject = request.Subject,
            BodyHtml = request.BodyHtml,
            Category = request.Category,
            IsActive = request.IsActive
        };
        var updated = await _repository.UpdateTemplateAsync(template);
        return updated ? NoContent() : NotFound();
    }

    [HttpDelete("templates/{id:int}")]
    public async Task<IActionResult> DeleteTemplate(int id)
    {
        var deleted = await _repository.DeleteTemplateAsync(id);
        return deleted ? NoContent() : BadRequest(new { message = "System templates cannot be deleted - deactivate instead." });
    }

    // ---- Manual send ----
    [HttpPost("send")]
    public async Task<IActionResult> SendEmail([FromBody] SendEmailRequest request)
    {
        string? toEmail = request.ToEmail;
        var placeholders = request.Placeholders ?? new Dictionary<string, string>();

        if (request.CandidateId.HasValue)
        {
            var candidate = await _candidateRepository.GetByIdAsync(request.CandidateId.Value);
            if (candidate is null) return NotFound(new { message = "Candidate not found." });

            toEmail ??= candidate.Email;
            placeholders.TryAdd("FirstName", candidate.FirstName);
            placeholders.TryAdd("LastName", candidate.LastName);
            placeholders.TryAdd("JobTitle", candidate.PositionApplied ?? "the role");
        }

        if (string.IsNullOrEmpty(toEmail))
            return BadRequest(new { message = "Either candidateId or toEmail is required." });

        await _emailService.SendTemplatedEmailAsync(request.TemplateCode, toEmail, placeholders, request.CandidateId, GetCurrentUserId());
        return Ok();
    }

    // ---- Log ----
    [HttpGet("log")]
    public async Task<ActionResult<IEnumerable<EmailLog>>> GetLog()
    {
        return Ok(await _repository.GetAllEmailLogsAsync());
    }

    [HttpGet("log/candidate/{candidateId:int}")]
    public async Task<ActionResult<IEnumerable<EmailLog>>> GetLogForCandidate(int candidateId)
    {
        return Ok(await _repository.GetEmailLogsByCandidateIdAsync(candidateId));
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }
}
