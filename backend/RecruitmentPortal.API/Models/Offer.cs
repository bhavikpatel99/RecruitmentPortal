namespace RecruitmentPortal.API.Models;

/// <summary>Maps to dbo.Offers (spec module 16).</summary>
public class Offer
{
    public int Id { get; set; }
    public int CandidateId { get; set; }
    public int? JobId { get; set; }
    public decimal BaseSalary { get; set; }
    public decimal? Bonus { get; set; }
    public string? EquityDetails { get; set; }
    public string? OtherBenefits { get; set; }
    public decimal? TotalCtc { get; set; }
    public DateTime? ValidUntil { get; set; }
    public string Status { get; set; } = "Draft";
    public string? SignedDocumentUrl { get; set; }
    public int? ApprovedBy { get; set; }
    public DateTime? ApprovedAt { get; set; }
    public DateTime? SentAt { get; set; }
    public DateTime? RespondedAt { get; set; }
    public int? CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

/// <summary>Maps to dbo.OfferAudit.</summary>
public class OfferAudit
{
    public int Id { get; set; }
    public int OfferId { get; set; }
    public string Action { get; set; } = string.Empty;
    public string? FromStatus { get; set; }
    public string? ToStatus { get; set; }
    public int? PerformedBy { get; set; }
    public string? Notes { get; set; }
    public DateTime PerformedAt { get; set; }
}
