namespace RecruitmentPortal.API.Models;

public class Department { public int Id { get; set; } public string Name { get; set; } = string.Empty; public bool IsActive { get; set; } = true; }

public class OfficeLocation { public int Id { get; set; } public string Name { get; set; } = string.Empty; public string? City { get; set; } public string? Country { get; set; } public bool IsActive { get; set; } = true; }

public class JobFamily { public int Id { get; set; } public string Name { get; set; } = string.Empty; public string? Description { get; set; } public bool IsActive { get; set; } = true; }

public class SkillMaster { public int Id { get; set; } public string Name { get; set; } = string.Empty; public string? Category { get; set; } public bool IsActive { get; set; } = true; }

public class Competency { public int Id { get; set; } public string Name { get; set; } = string.Empty; public string? Description { get; set; } public bool IsActive { get; set; } = true; }

public class SalaryBand
{
    public int Id { get; set; }
    public int? JobFamilyId { get; set; }
    public string? JobFamilyName { get; set; }
    public string Level { get; set; } = string.Empty;
    public decimal MinSalary { get; set; }
    public decimal MaxSalary { get; set; }
    public string Currency { get; set; } = "INR";
    public bool IsActive { get; set; } = true;
}

public class ApprovalMatrix
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public decimal? MinAmount { get; set; }
    public decimal? MaxAmount { get; set; }
    public string RequiredApproverRole { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
}

public class InterviewPanelMaster
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;
    public int? CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int MemberCount { get; set; }
}

public class InterviewPanelMasterMember
{
    public int Id { get; set; }
    public int PanelId { get; set; }
    public int UserId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
}
