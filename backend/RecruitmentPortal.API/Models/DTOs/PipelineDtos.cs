using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

/// <summary>Payload used to move a candidate to a new pipeline stage.</summary>
public class ChangeStageRequest
{
    [Required, StringLength(50)]
    public string NewStatus { get; set; } = string.Empty;

    [StringLength(200)]
    public string? Reason { get; set; }

    public string? Notes { get; set; }
}
