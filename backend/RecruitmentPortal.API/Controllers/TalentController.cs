using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Candidate 360 (notes, tags), talent pools, and search/saved-searches (spec modules 10 & 23).</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class TalentController : ControllerBase
{
    private readonly ITalentRepository _repository;

    public TalentController(ITalentRepository repository)
    {
        _repository = repository;
    }

    // ---- Notes ----
    [HttpGet("candidates/{candidateId:int}/notes")]
    public async Task<ActionResult<IEnumerable<CandidateNote>>> GetNotes(int candidateId)
    {
        return Ok(await _repository.GetNotesAsync(candidateId));
    }

    [HttpPost("candidates/{candidateId:int}/notes")]
    public async Task<IActionResult> AddNote(int candidateId, [FromBody] CandidateNoteRequest request)
    {
        var id = await _repository.AddNoteAsync(candidateId, request.Note, GetCurrentUserId());
        return Ok(new { id });
    }

    // ---- Tags ----
    [HttpGet("candidates/{candidateId:int}/tags")]
    public async Task<ActionResult<IEnumerable<CandidateTag>>> GetTags(int candidateId)
    {
        return Ok(await _repository.GetTagsAsync(candidateId));
    }

    [HttpPost("candidates/{candidateId:int}/tags")]
    public async Task<IActionResult> AddTag(int candidateId, [FromBody] CandidateTagRequest request)
    {
        var id = await _repository.AddTagAsync(candidateId, request.Tag, GetCurrentUserId());
        return Ok(new { id });
    }

    [HttpDelete("tags/{id:int}")]
    public async Task<IActionResult> RemoveTag(int id)
    {
        var removed = await _repository.RemoveTagAsync(id);
        return removed ? NoContent() : NotFound();
    }

    [HttpGet("tags")]
    public async Task<ActionResult<IEnumerable<string>>> GetAllTags()
    {
        return Ok(await _repository.GetAllDistinctTagsAsync());
    }

    // ---- Talent pools ----
    [HttpGet("pools")]
    public async Task<ActionResult<IEnumerable<TalentPool>>> GetPools()
    {
        return Ok(await _repository.GetPoolsAsync());
    }

    [HttpPost("pools")]
    public async Task<IActionResult> CreatePool([FromBody] TalentPoolRequest request)
    {
        var id = await _repository.CreatePoolAsync(request.Name, request.Description, GetCurrentUserId());
        return Ok(new { id });
    }

    [HttpGet("pools/{poolId:int}/members")]
    public async Task<ActionResult<IEnumerable<TalentPoolMember>>> GetPoolMembers(int poolId)
    {
        return Ok(await _repository.GetPoolMembersAsync(poolId));
    }

    [HttpPost("pools/{poolId:int}/members/{candidateId:int}")]
    public async Task<IActionResult> AddPoolMember(int poolId, int candidateId)
    {
        await _repository.AddPoolMemberAsync(poolId, candidateId, GetCurrentUserId());
        return NoContent();
    }

    [HttpDelete("pools/{poolId:int}/members/{candidateId:int}")]
    public async Task<IActionResult> RemovePoolMember(int poolId, int candidateId)
    {
        var removed = await _repository.RemovePoolMemberAsync(poolId, candidateId);
        return removed ? NoContent() : NotFound();
    }

    [HttpGet("candidates/{candidateId:int}/pools")]
    public async Task<ActionResult<IEnumerable<TalentPoolSummary>>> GetPoolsForCandidate(int candidateId)
    {
        return Ok(await _repository.GetPoolsForCandidateAsync(candidateId));
    }

    // ---- Search ----
    [HttpPost("search")]
    public async Task<ActionResult<IEnumerable<CandidateSearchResult>>> Search([FromBody] CandidateSearchRequest request)
    {
        return Ok(await _repository.SearchAsync(request));
    }

    [HttpGet("saved-searches")]
    public async Task<ActionResult<IEnumerable<SavedSearch>>> GetSavedSearches()
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized();
        return Ok(await _repository.GetSavedSearchesAsync(userId.Value));
    }

    [HttpPost("saved-searches")]
    public async Task<IActionResult> SaveSearch([FromBody] SavedSearchRequest request)
    {
        var userId = GetCurrentUserId();
        if (userId is null) return Unauthorized();
        var id = await _repository.SaveSearchAsync(userId.Value, request);
        return Ok(new { id });
    }

    [HttpDelete("saved-searches/{id:int}")]
    public async Task<IActionResult> DeleteSavedSearch(int id)
    {
        var deleted = await _repository.DeleteSavedSearchAsync(id);
        return deleted ? NoContent() : NotFound();
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }
}
