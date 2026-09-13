using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Employee Referral Portal (spec module 19): generate a referral link, track status, and manage bonus payouts.</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class ReferralController : ControllerBase
{
    private readonly IAgencyReferralRepository _repository;

    public ReferralController(IAgencyReferralRepository repository)
    {
        _repository = repository;
    }

    /// <summary>Generate a shareable referral link/code for a job.</summary>
    [HttpPost("link")]
    public async Task<IActionResult> CreateLink([FromBody] ReferralLinkRequest request)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized();

        var (id, code) = await _repository.CreateReferralLinkAsync(userId.Value, request.JobId);
        return Ok(new { id, referralCode = code });
    }

    /// <summary>Validate a referral code and return which job it points to - used by the public application form.</summary>
    [HttpGet("validate/{code}")]
    [AllowAnonymous]
    public async Task<IActionResult> Validate(string code)
    {
        var referral = await _repository.GetReferralByCodeAsync(code);
        if (referral is null) return NotFound(new { message = "Invalid or expired referral link." });
        return Ok(new { referral.JobId, referral.JobTitle });
    }

    [HttpGet("mine")]
    public async Task<ActionResult<IEnumerable<Referral>>> GetMine()
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized();
        return Ok(await _repository.GetReferralsByReferrerAsync(userId.Value));
    }

    [HttpGet]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<ActionResult<IEnumerable<Referral>>> GetAll() => Ok(await _repository.GetAllReferralsAsync());

    [HttpPost("{id:int}/bonus")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> UpdateBonus(int id, [FromBody] ReferralBonusRequest request)
    {
        var updated = await _repository.UpdateReferralBonusAsync(id, request.BonusAmount, request.BonusStatus);
        return updated ? NoContent() : NotFound();
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }
}
