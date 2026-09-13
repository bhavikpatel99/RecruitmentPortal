using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for dbo.Offers and its audit trail.</summary>
public sealed class OfferRepository : IOfferRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public OfferRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<int> CreateAsync(Offer offer)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_Offer_Create",
            new
            {
                offer.CandidateId,
                offer.JobId,
                offer.BaseSalary,
                offer.Bonus,
                offer.EquityDetails,
                offer.OtherBenefits,
                offer.TotalCtc,
                offer.ValidUntil,
                offer.CreatedBy
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<Offer>> GetAllAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Offer>("sp_Offer_GetAll", commandType: CommandType.StoredProcedure);
    }

    public async Task<Offer?> GetByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<Offer>(
            "sp_Offer_GetById", new { Id = id }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<Offer>> GetByCandidateIdAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Offer>(
            "sp_Offer_GetByCandidateId", new { CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> UpdateAsync(Offer offer)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Offer_Update",
            new { offer.Id, offer.BaseSalary, offer.Bonus, offer.EquityDetails, offer.OtherBenefits, offer.TotalCtc, offer.ValidUntil },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> UpdateStatusAsync(int id, string newStatus, int? performedBy, string? notes, string? signedDocumentUrl)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Offer_UpdateStatus",
            new { Id = id, NewStatus = newStatus, PerformedBy = performedBy, Notes = notes, SignedDocumentUrl = signedDocumentUrl },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> LogNegotiationAsync(int offerId, string notes, decimal? newBaseSalary, decimal? newTotalCtc, int? performedBy)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_Offer_LogNegotiation",
            new { OfferId = offerId, Notes = notes, NewBaseSalary = newBaseSalary, NewTotalCtc = newTotalCtc, PerformedBy = performedBy },
            commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<IEnumerable<OfferAudit>> GetAuditAsync(int offerId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<OfferAudit>(
            "sp_Offer_GetAudit", new { OfferId = offerId }, commandType: CommandType.StoredProcedure);
    }
}
