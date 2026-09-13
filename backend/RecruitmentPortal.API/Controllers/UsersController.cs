using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Controllers;

/// <summary>Internal staff directory - used to pick interviewers, hiring managers and recruiters in the workspace UI.</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class UsersController : ControllerBase
{
    private readonly IUserRepository _repository;

    public UsersController(IUserRepository repository)
    {
        _repository = repository;
    }

    /// <summary>List internal users, optionally filtered by role (Admin, Recruiter, HiringManager, Candidate).</summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<UserSummaryDto>>> GetAll([FromQuery] string? role)
    {
        return Ok(await _repository.GetAllAsync(role));
    }
}
