using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class JobsController : ControllerBase
{
    private readonly IJobRepository _repository;
    private readonly ILogger<JobsController> _logger;

    public JobsController(IJobRepository repository, ILogger<JobsController> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    /// <summary>List all jobs.</summary>
    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<IEnumerable<Job>>> GetAll()
    {
        var jobs = await _repository.GetAllAsync();
        return Ok(jobs);
    }

    /// <summary>Get a single job by id.</summary>
    [HttpGet("{id:int}")]
    [AllowAnonymous]
    public async Task<ActionResult<Job>> GetById(int id)
    {
        var job = await _repository.GetByIdAsync(id);
        return job is null ? NotFound() : Ok(job);
    }

    /// <summary>List all open jobs.</summary>
    [HttpGet("open")]
    [AllowAnonymous]
    public async Task<ActionResult<IEnumerable<Job>>> GetOpenJobs()
    {
        var jobs = await _repository.GetOpenJobsAsync();
        return Ok(jobs);
    }

    /// <summary>Create a new job posting.</summary>
    [HttpPost]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<ActionResult<Job>> Create([FromBody] JobRequest request)
    {
        try
        {
            var job = MapToJob(request, new Job());
            job.PostedDate = DateTime.UtcNow;
            job.Status = "Open";
            job.PostedBy = GetCurrentUserId();

            _logger.LogInformation("Creating job: {Title} in {Department}", job.Title, job.Department);

            job.Id = await _repository.CreateAsync(job);

            _logger.LogInformation("Job created successfully with Id: {Id}", job.Id);
            return CreatedAtAction(nameof(GetById), new { id = job.Id }, job);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to create job");
            return BadRequest(new { message = "Failed to create job. Please check the submitted details and try again." });
        }
    }

    /// <summary>Update a job posting.</summary>
    [HttpPut("{id:int}")]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<IActionResult> Update(int id, [FromBody] JobRequest request)
    {
        try
        {
            var existing = await _repository.GetByIdAsync(id);
            if (existing is null)
            {
                _logger.LogWarning("Job {Id} not found for update", id);
                return NotFound();
            }

            var job = MapToJob(request, existing);
            job.Id = id;
            job.PostedDate = existing.PostedDate;
            job.PostedBy = existing.PostedBy;
            job.Status = string.IsNullOrWhiteSpace(request.Status) ? existing.Status : request.Status;

            _logger.LogInformation("Updating job {Id}: {Title}", id, job.Title);

            var updated = await _repository.UpdateAsync(job);

            if (updated)
            {
                _logger.LogInformation("Job {Id} updated successfully", id);
                return NoContent();
            }

            _logger.LogError("Failed to update job {Id} - no rows affected", id);
            return BadRequest(new { message = "Failed to update job - no rows affected." });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to update job {Id}", id);
            return BadRequest(new { message = "Failed to update job. Please check the submitted details and try again." });
        }
    }

    private static Job MapToJob(JobRequest request, Job target)
    {
        target.Title = request.Title;
        target.Description = request.Description;
        target.Requirements = request.Requirements;
        target.Responsibilities = request.Responsibilities;
        target.Location = request.Location;
        target.EmploymentType = request.EmploymentType;
        target.SalaryMin = request.SalaryMin;
        target.SalaryMax = request.SalaryMax;
        target.ExperienceYearsMin = request.ExperienceYearsMin;
        target.ExperienceYearsMax = request.ExperienceYearsMax;
        target.Skills = request.Skills;
        target.Department = request.Department;
        target.ClosedDate = request.ClosedDate;
        target.MustHaveSkills = request.MustHaveSkills;
        target.NiceToHaveSkills = request.NiceToHaveSkills;
        target.EducationRequirement = request.EducationRequirement;
        target.WorkMode = request.WorkMode;
        target.BenefitsText = request.BenefitsText;
        target.LegalText = request.LegalText;
        target.JobRequisitionId = request.JobRequisitionId;
        return target;
    }

    /// <summary>Delete a job posting.</summary>
    [HttpDelete("{id:int}")]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _repository.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }

    /// <summary>List the distribution channels (career site, job boards, social) this job has been posted to.</summary>
    [HttpGet("{id:int}/channels")]
    [Authorize(Roles = "Admin,Recruiter,HiringManager")]
    public async Task<ActionResult<IEnumerable<JobPostingChannel>>> GetChannels(int id)
    {
        return Ok(await _repository.GetPostingChannelsAsync(id));
    }

    /// <summary>Record that this job has been published to a channel (career site, LinkedIn, Indeed, etc).</summary>
    [HttpPost("{id:int}/channels")]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<IActionResult> AddChannel(int id, [FromBody] JobPostingChannelRequest request)
    {
        var channelId = await _repository.AddPostingChannelAsync(id, request.Channel, request.ExternalUrl, request.ExpiryDate, GetCurrentUserId());
        return Ok(new { id = channelId });
    }

    [HttpPost("channels/{channelId:int}/status")]
    [Authorize(Roles = "Admin,Recruiter")]
    public async Task<IActionResult> UpdateChannelStatus(int channelId, [FromBody] JobPostingChannelStatusRequest request)
    {
        var updated = await _repository.UpdatePostingChannelStatusAsync(channelId, request.Status);
        return updated ? NoContent() : NotFound();
    }

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }
}
