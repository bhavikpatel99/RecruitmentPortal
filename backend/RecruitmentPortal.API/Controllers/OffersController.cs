using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;
using RecruitmentPortal.API.Services;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Offer creation, approval, send/withdraw/resend, acceptance/rejection, negotiation log (spec module 16).</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class OffersController : ControllerBase
{
    private readonly IOfferRepository _repository;
    private readonly ICandidateRepository _candidateRepository;
    private readonly IEmailService _emailService;

    public OffersController(IOfferRepository repository, ICandidateRepository candidateRepository, IEmailService emailService)
    {
        _repository = repository;
        _candidateRepository = candidateRepository;
        _emailService = emailService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Offer>>> GetAll()
    {
        return Ok(await _repository.GetAllAsync());
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<Offer>> GetById(int id)
    {
        var offer = await _repository.GetByIdAsync(id);
        return offer is null ? NotFound() : Ok(offer);
    }

    [HttpGet("candidate/{candidateId:int}")]
    public async Task<ActionResult<IEnumerable<Offer>>> GetByCandidate(int candidateId)
    {
        return Ok(await _repository.GetByCandidateIdAsync(candidateId));
    }

    [HttpGet("{id:int}/audit")]
    public async Task<ActionResult<IEnumerable<OfferAudit>>> GetAudit(int id)
    {
        return Ok(await _repository.GetAuditAsync(id));
    }

    [HttpPost]
    public async Task<ActionResult<Offer>> Create([FromBody] OfferRequest request)
    {
        var offer = new Offer
        {
            CandidateId = request.CandidateId,
            JobId = request.JobId,
            BaseSalary = request.BaseSalary,
            Bonus = request.Bonus,
            EquityDetails = request.EquityDetails,
            OtherBenefits = request.OtherBenefits,
            TotalCtc = request.TotalCtc,
            ValidUntil = request.ValidUntil,
            CreatedBy = GetCurrentUserId()
        };
        offer.Id = await _repository.CreateAsync(offer);
        return CreatedAtAction(nameof(GetById), new { id = offer.Id }, offer);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] OfferRequest request)
    {
        var offer = new Offer
        {
            Id = id,
            BaseSalary = request.BaseSalary,
            Bonus = request.Bonus,
            EquityDetails = request.EquityDetails,
            OtherBenefits = request.OtherBenefits,
            TotalCtc = request.TotalCtc,
            ValidUntil = request.ValidUntil
        };
        var updated = await _repository.UpdateAsync(offer);
        return updated ? NoContent() : BadRequest(new { message = "Offer can only be edited while in Draft status." });
    }

    /// <summary>Submit/Approve/Reject/Send/Accept/Reject/Withdraw transition. Accepting cascades into pre-joining + a Hire event.</summary>
    [HttpPost("{id:int}/status")]
    public async Task<IActionResult> UpdateStatus(int id, [FromBody] OfferStatusRequest request)
    {
        var updated = await _repository.UpdateStatusAsync(id, request.NewStatus, GetCurrentUserId(), request.Notes, request.SignedDocumentUrl);

        if (updated && request.NewStatus == "Sent")
        {
            var offer = await _repository.GetByIdAsync(id);
            var candidate = offer is not null ? await _candidateRepository.GetByIdAsync(offer.CandidateId) : null;
            if (offer is not null && candidate is not null)
            {
                await _emailService.SendTemplatedEmailAsync("OfferSent", candidate.Email, new Dictionary<string, string>
                {
                    ["FirstName"] = candidate.FirstName,
                    ["JobTitle"] = candidate.PositionApplied ?? "the role",
                    ["BaseSalary"] = offer.BaseSalary.ToString("N0"),
                    ["ValidUntil"] = offer.ValidUntil?.ToString("MMMM d, yyyy") ?? "further notice"
                }, candidate.Id, GetCurrentUserId());
            }
        }

        return updated ? NoContent() : NotFound();
    }

    [HttpPost("{id:int}/negotiation")]
    public async Task<IActionResult> LogNegotiation(int id, [FromBody] OfferNegotiationRequest request)
    {
        var updated = await _repository.LogNegotiationAsync(id, request.Notes, request.NewBaseSalary, request.NewTotalCtc, GetCurrentUserId());
        return updated ? NoContent() : NotFound();
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }
}
