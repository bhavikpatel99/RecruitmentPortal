using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Pre-joining checklist, BGV status, and the structured Hire-event handoff to HR/ERP (spec module 17).</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class PreJoiningController : ControllerBase
{
    private readonly IPreJoiningRepository _repository;

    public PreJoiningController(IPreJoiningRepository repository)
    {
        _repository = repository;
    }

    [HttpGet("candidate/{candidateId:int}")]
    public async Task<ActionResult<IEnumerable<PreJoiningChecklist>>> GetByCandidate(int candidateId)
    {
        return Ok(await _repository.GetByCandidateIdAsync(candidateId));
    }

    [HttpGet("{checklistId:int}/tasks")]
    public async Task<ActionResult<IEnumerable<PreJoiningTask>>> GetTasks(int checklistId)
    {
        return Ok(await _repository.GetTasksAsync(checklistId));
    }

    [HttpPost("{checklistId:int}/joining-date")]
    public async Task<IActionResult> SetJoiningDate(int checklistId, [FromBody] JoiningDateRequest request)
    {
        var updated = await _repository.SetJoiningDateAsync(checklistId, request.JoiningDate);
        return updated ? NoContent() : NotFound();
    }

    [HttpPost("{checklistId:int}/bgv-status")]
    public async Task<IActionResult> UpdateBgvStatus(int checklistId, [FromBody] BgvStatusRequest request)
    {
        var updated = await _repository.UpdateBgvStatusAsync(checklistId, request.BgvStatus);
        return updated ? NoContent() : NotFound();
    }

    [HttpPost("{checklistId:int}/tasks")]
    public async Task<IActionResult> AddTask(int checklistId, [FromBody] PreJoiningTaskRequest request)
    {
        var id = await _repository.AddTaskAsync(checklistId, request.TaskName, request.SortOrder);
        return Ok(new { id });
    }

    [HttpPatch("tasks/{id:int}")]
    public async Task<IActionResult> ToggleTask(int id, [FromBody] TaskToggleRequest request)
    {
        var updated = await _repository.ToggleTaskAsync(id, request.IsCompleted);
        return updated ? NoContent() : NotFound();
    }

    [HttpGet("hire-events")]
    public async Task<ActionResult<IEnumerable<HireEvent>>> GetAllHireEvents()
    {
        return Ok(await _repository.GetAllHireEventsAsync());
    }

    [HttpGet("hire-events/candidate/{candidateId:int}")]
    public async Task<ActionResult<IEnumerable<HireEvent>>> GetHireEventsForCandidate(int candidateId)
    {
        return Ok(await _repository.GetHireEventsByCandidateIdAsync(candidateId));
    }

    /// <summary>Simulates the outbound webhook to HR/ERP succeeding, since there's no live ERP configured.</summary>
    [HttpPost("hire-events/{id:int}/mark-sent")]
    public async Task<IActionResult> MarkHireEventSent(int id)
    {
        var updated = await _repository.MarkHireEventSentAsync(id);
        return updated ? NoContent() : NotFound();
    }
}
