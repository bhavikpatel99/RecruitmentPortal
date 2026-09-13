using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Repositories;

namespace RecruitmentPortal.API.Controllers;

public class NamedItemRequest { public string Name { get; set; } = string.Empty; public string? Description { get; set; } }
public class LocationRequest { public string Name { get; set; } = string.Empty; public string? City { get; set; } public string? Country { get; set; } }
public class SalaryBandRequest { public int? JobFamilyId { get; set; } public string Level { get; set; } = string.Empty; public decimal MinSalary { get; set; } public decimal MaxSalary { get; set; } public string Currency { get; set; } = "INR"; }
public class ApprovalMatrixRequest { public string Name { get; set; } = string.Empty; public string? Description { get; set; } public decimal? MinAmount { get; set; } public decimal? MaxAmount { get; set; } public string RequiredApproverRole { get; set; } = string.Empty; }

/// <summary>Organization & Hiring Setup master data (spec module 2): departments, locations, job families, skills, competencies, salary bands, approval matrices, reusable interview panels.</summary>
[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "Admin,Recruiter,HiringManager")]
public class OrgSetupController : ControllerBase
{
    private readonly IOrgSetupRepository _repository;

    public OrgSetupController(IOrgSetupRepository repository)
    {
        _repository = repository;
    }

    // Departments
    [HttpGet("departments")] public async Task<ActionResult<IEnumerable<Department>>> GetDepartments() => Ok(await _repository.GetDepartmentsAsync());
    [HttpPost("departments")] [Authorize(Roles = "Admin")] public async Task<IActionResult> CreateDepartment([FromBody] NamedItemRequest r) => Ok(new { id = await _repository.CreateDepartmentAsync(r.Name) });
    [HttpDelete("departments/{id:int}")] [Authorize(Roles = "Admin")] public async Task<IActionResult> DeleteDepartment(int id) => await _repository.DeleteDepartmentAsync(id) ? NoContent() : NotFound();

    // Locations
    [HttpGet("locations")] public async Task<ActionResult<IEnumerable<OfficeLocation>>> GetLocations() => Ok(await _repository.GetLocationsAsync());
    [HttpPost("locations")] [Authorize(Roles = "Admin")] public async Task<IActionResult> CreateLocation([FromBody] LocationRequest r) => Ok(new { id = await _repository.CreateLocationAsync(r.Name, r.City, r.Country) });
    [HttpDelete("locations/{id:int}")] [Authorize(Roles = "Admin")] public async Task<IActionResult> DeleteLocation(int id) => await _repository.DeleteLocationAsync(id) ? NoContent() : NotFound();

    // Job families
    [HttpGet("job-families")] public async Task<ActionResult<IEnumerable<JobFamily>>> GetJobFamilies() => Ok(await _repository.GetJobFamiliesAsync());
    [HttpPost("job-families")] [Authorize(Roles = "Admin")] public async Task<IActionResult> CreateJobFamily([FromBody] NamedItemRequest r) => Ok(new { id = await _repository.CreateJobFamilyAsync(r.Name, r.Description) });
    [HttpDelete("job-families/{id:int}")] [Authorize(Roles = "Admin")] public async Task<IActionResult> DeleteJobFamily(int id) => await _repository.DeleteJobFamilyAsync(id) ? NoContent() : NotFound();

    // Skills
    [HttpGet("skills")] public async Task<ActionResult<IEnumerable<SkillMaster>>> GetSkills() => Ok(await _repository.GetSkillsAsync());
    [HttpPost("skills")] [Authorize(Roles = "Admin,Recruiter")] public async Task<IActionResult> CreateSkill([FromBody] NamedItemRequest r) => Ok(new { id = await _repository.CreateSkillAsync(r.Name, r.Description) });
    [HttpDelete("skills/{id:int}")] [Authorize(Roles = "Admin")] public async Task<IActionResult> DeleteSkill(int id) => await _repository.DeleteSkillAsync(id) ? NoContent() : NotFound();

    // Competencies
    [HttpGet("competencies")] public async Task<ActionResult<IEnumerable<Competency>>> GetCompetencies() => Ok(await _repository.GetCompetenciesAsync());
    [HttpPost("competencies")] [Authorize(Roles = "Admin")] public async Task<IActionResult> CreateCompetency([FromBody] NamedItemRequest r) => Ok(new { id = await _repository.CreateCompetencyAsync(r.Name, r.Description) });
    [HttpDelete("competencies/{id:int}")] [Authorize(Roles = "Admin")] public async Task<IActionResult> DeleteCompetency(int id) => await _repository.DeleteCompetencyAsync(id) ? NoContent() : NotFound();

    // Salary bands
    [HttpGet("salary-bands")] public async Task<ActionResult<IEnumerable<SalaryBand>>> GetSalaryBands() => Ok(await _repository.GetSalaryBandsAsync());
    [HttpPost("salary-bands")] [Authorize(Roles = "Admin")] public async Task<IActionResult> CreateSalaryBand([FromBody] SalaryBandRequest r) => Ok(new { id = await _repository.CreateSalaryBandAsync(r.JobFamilyId, r.Level, r.MinSalary, r.MaxSalary, r.Currency) });
    [HttpDelete("salary-bands/{id:int}")] [Authorize(Roles = "Admin")] public async Task<IActionResult> DeleteSalaryBand(int id) => await _repository.DeleteSalaryBandAsync(id) ? NoContent() : NotFound();

    // Approval matrices
    [HttpGet("approval-matrices")] public async Task<ActionResult<IEnumerable<ApprovalMatrix>>> GetApprovalMatrices() => Ok(await _repository.GetApprovalMatricesAsync());
    [HttpPost("approval-matrices")] [Authorize(Roles = "Admin")] public async Task<IActionResult> CreateApprovalMatrix([FromBody] ApprovalMatrixRequest r) => Ok(new { id = await _repository.CreateApprovalMatrixAsync(r.Name, r.Description, r.MinAmount, r.MaxAmount, r.RequiredApproverRole) });
    [HttpDelete("approval-matrices/{id:int}")] [Authorize(Roles = "Admin")] public async Task<IActionResult> DeleteApprovalMatrix(int id) => await _repository.DeleteApprovalMatrixAsync(id) ? NoContent() : NotFound();

    // Reusable interview panels
    [HttpGet("interview-panels")] public async Task<ActionResult<IEnumerable<InterviewPanelMaster>>> GetInterviewPanels() => Ok(await _repository.GetInterviewPanelsAsync());
    [HttpPost("interview-panels")] public async Task<IActionResult> CreateInterviewPanel([FromBody] NamedItemRequest r) => Ok(new { id = await _repository.CreateInterviewPanelAsync(r.Name, r.Description, GetCurrentUserId()) });
    [HttpDelete("interview-panels/{id:int}")] [Authorize(Roles = "Admin")] public async Task<IActionResult> DeleteInterviewPanel(int id) => await _repository.DeleteInterviewPanelAsync(id) ? NoContent() : NotFound();
    [HttpGet("interview-panels/{id:int}/members")] public async Task<ActionResult<IEnumerable<InterviewPanelMasterMember>>> GetInterviewPanelMembers(int id) => Ok(await _repository.GetInterviewPanelMembersAsync(id));
    [HttpPost("interview-panels/{id:int}/members/{userId:int}")] public async Task<IActionResult> AddInterviewPanelMember(int id, int userId) { await _repository.AddInterviewPanelMemberAsync(id, userId); return NoContent(); }
    [HttpDelete("interview-panels/{id:int}/members/{userId:int}")] public async Task<IActionResult> RemoveInterviewPanelMember(int id, int userId) => await _repository.RemoveInterviewPanelMemberAsync(id, userId) ? NoContent() : NotFound();

    private int? GetCurrentUserId()
    {
        var value = User.FindFirstValue(ClaimTypes.NameIdentifier);
        return int.TryParse(value, out var id) ? id : null;
    }
}
