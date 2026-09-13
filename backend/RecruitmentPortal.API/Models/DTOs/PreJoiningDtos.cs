using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

public class JoiningDateRequest
{
    [Required]
    public DateTime JoiningDate { get; set; }
}

public class BgvStatusRequest
{
    [Required, StringLength(30)]
    public string BgvStatus { get; set; } = string.Empty; // NotStarted, InProgress, Cleared, Flagged
}

public class PreJoiningTaskRequest
{
    [Required, StringLength(200)]
    public string TaskName { get; set; } = string.Empty;

    public int SortOrder { get; set; } = 99;
}

public class TaskToggleRequest
{
    public bool IsCompleted { get; set; }
}
