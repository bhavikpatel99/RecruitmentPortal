using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

public interface IOfferRepository
{
    Task<int> CreateAsync(Offer offer);
    Task<IEnumerable<Offer>> GetAllAsync();
    Task<Offer?> GetByIdAsync(int id);
    Task<IEnumerable<Offer>> GetByCandidateIdAsync(int candidateId);
    Task<bool> UpdateAsync(Offer offer);
    Task<bool> UpdateStatusAsync(int id, string newStatus, int? performedBy, string? notes, string? signedDocumentUrl);
    Task<bool> LogNegotiationAsync(int offerId, string notes, decimal? newBaseSalary, decimal? newTotalCtc, int? performedBy);
    Task<IEnumerable<OfferAudit>> GetAuditAsync(int offerId);
}
