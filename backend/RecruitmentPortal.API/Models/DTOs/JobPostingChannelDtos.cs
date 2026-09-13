using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

public class JobPostingChannelRequest
{
    [Required, StringLength(50)]
    public string Channel { get; set; } = string.Empty; // CareerSite, LinkedIn, Indeed, Naukri, Referral, Other

    [StringLength(500)]
    public string? ExternalUrl { get; set; }

    public DateTime? ExpiryDate { get; set; }
}

public class JobPostingChannelStatusRequest
{
    [Required, StringLength(20)]
    public string Status { get; set; } = string.Empty; // Active, Expired, Removed
}
