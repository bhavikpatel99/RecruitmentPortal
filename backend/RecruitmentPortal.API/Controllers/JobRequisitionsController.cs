using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Manpower request / job requisition lifecycle: draft, submit, approve, reject, hold, reopen, close.</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class JobRequisitionsController : ControllerBase
{
    private readonly IJobRequisitionRepository _repository;
    private readonly ILogger<JobRequisitionsController> _logger;

    public JobRequisitionsController(IJobRequisitionRepository repository, ILogger<JobRequisitionsController> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    /// <summary>List all job requisitions.</summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<JobRequisition>>> GetAll()
    {
        return Ok(await _repository.GetAllAsync());
    }

    /// <summary>Get a single job requisition by id.</summary>
    [HttpGet("{id:int}")]
    public async Task<ActionResult<JobRequisition>> GetById(int id)
    {
        var requisition = await _repository.GetByIdAsync(id);
        return requisition is null ? NotFound() : Ok(requisition);
    }

    /// <summary>Get the approval/status audit trail for a requisition.</summary>
    [HttpGet("{id:int}/audit")]
    public async Task<ActionResult<IEnumerable<JobRequisitionAudit>>> GetAudit(int id)
    {
        return Ok(await _repository.GetAuditAsync(id));
    }

    /// <summary>Create a new manpower request / job requisition in Draft status.</summary>
    [HttpPost]
    public async Task<ActionResult<JobRequisition>> Create([FromBody] JobRequisitionRequest request)
    {
        try
        {
            var requisition = MapToEntity(request);
            requisition.CreatedBy = GetCurrentUserId();

            _logger.LogInformation("Creating job requisition: {Title} ({Department})", requisition.Title, requisition.Department);

            requisition.Id = await _repository.CreateAsync(requisition);
            return CreatedAtAction(nameof(GetById), new { id = requisition.Id }, requisition);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to create job requisition");
            return BadRequest(new { message = "Failed to create job requisition. Please check the submitted details and try again." });
        }
    }

    /// <summary>Edit a requisition still in Draft or OnHold status.</summary>
    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] JobRequisitionRequest request)
    {
        var existing = await _repository.GetByIdAsync(id);
        if (existing is null)
            return NotFound();

        var requisition = MapToEntity(request);
        requisition.Id = id;

        var updated = await _repository.UpdateAsync(requisition);
        if (updated)
            return NoContent();

        return BadRequest(new { message = "Requisition can only be edited while in Draft or OnHold status." });
    }

    /// <summary>Transition status: Submit for approval, Approve, Reject, Hold, Reopen or Close.</summary>
    [HttpPost("{id:int}/status")]
    public async Task<IActionResult> UpdateStatus(int id, [FromBody] JobRequisitionStatusRequest request)
    {
        var performedBy = GetCurrentUserId();

        _logger.LogInformation("Transitioning requisition {Id} to {NewStatus}", id, request.NewStatus);

        var updated = await _repository.UpdateStatusAsync(id, request.NewStatus, performedBy, request.RejectionReason, request.Notes);
        return updated ? NoContent() : NotFound();
    }

    /// <summary>Link this requisition to a published job posting once the JD goes live.</summary>
    [HttpPost("{id:int}/link-job/{jobId:int}")]
    public async Task<IActionResult> LinkJob(int id, int jobId)
    {
        var linked = await _repository.LinkJobAsync(id, jobId);
        return linked ? NoContent() : NotFound();
    }

    /// <summary>Delete a requisition that is still in Draft status.</summary>
    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _repository.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }

    private static JobRequisition MapToEntity(JobRequisitionRequest r) => new()
    {
        Title = r.Title,
        Department = r.Department,
        Location = r.Location,
        EmploymentType = r.EmploymentType,
        Vacancies = r.Vacancies,
        Priority = r.Priority,
        RequisitionType = r.RequisitionType,
        TargetJoiningDate = r.TargetJoiningDate,
        BudgetReference = r.BudgetReference,
        JustificationNotes = r.JustificationNotes,
        RequiredSkills = r.RequiredSkills,
        HiringManagerId = r.HiringManagerId,
        RecruiterId = r.RecruiterId,
        JobId = r.JobId
    };
}
