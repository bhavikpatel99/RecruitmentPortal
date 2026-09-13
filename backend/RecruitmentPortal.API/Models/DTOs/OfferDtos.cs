using System.ComponentModel.DataAnnotations;

namespace RecruitmentPortal.API.Models.DTOs;

public class OfferRequest
{
    [Required]
    public int CandidateId { get; set; }

    public int? JobId { get; set; }

    [Required]
    public decimal BaseSalary { get; set; }

    public decimal? Bonus { get; set; }

    [StringLength(300)]
    public string? EquityDetails { get; set; }

    [StringLength(1000)]
    public string? OtherBenefits { get; set; }

    public decimal? TotalCtc { get; set; }

    public DateTime? ValidUntil { get; set; }
}

public class OfferStatusRequest
{
    [Required, StringLength(30)]
    public string NewStatus { get; set; } = string.Empty;

    [StringLength(1000)]
    public string? Notes { get; set; }

    [StringLength(500)]
    public string? SignedDocumentUrl { get; set; }
}

public class OfferNegotiationRequest
{
    [Required, StringLength(1000)]
    public string Notes { get; set; } = string.Empty;

    public decimal? NewBaseSalary { get; set; }
    public decimal? NewTotalCtc { get; set; }
}
