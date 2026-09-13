using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for candidate notes, tags, talent pools, search and saved searches.</summary>
public sealed class TalentRepository : ITalentRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public TalentRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<int> AddNoteAsync(int candidateId, string note, int? createdBy)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_CandidateNote_Add", new { CandidateId = candidateId, Note = note, CreatedBy = createdBy }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<CandidateNote>> GetNotesAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<CandidateNote>(
            "sp_CandidateNote_GetByCandidateId", new { CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<int> AddTagAsync(int candidateId, string tag, int? createdBy)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_CandidateTag_Add", new { CandidateId = candidateId, Tag = tag, CreatedBy = createdBy }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<CandidateTag>> GetTagsAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<CandidateTag>(
            "sp_CandidateTag_GetByCandidateId", new { CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> RemoveTagAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_CandidateTag_Remove", new { Id = id }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<IEnumerable<string>> GetAllDistinctTagsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<string>("sp_CandidateTag_GetAllDistinct", commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreatePoolAsync(string name, string? description, int? createdBy)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_TalentPool_Create", new { Name = name, Description = description, CreatedBy = createdBy }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<TalentPool>> GetPoolsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<TalentPool>("sp_TalentPool_GetAll", commandType: CommandType.StoredProcedure);
    }

    public async Task<int> AddPoolMemberAsync(int poolId, int candidateId, int? addedBy)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_TalentPool_AddMember", new { TalentPoolId = poolId, CandidateId = candidateId, AddedBy = addedBy }, commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> RemovePoolMemberAsync(int poolId, int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_TalentPool_RemoveMember", new { TalentPoolId = poolId, CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<IEnumerable<TalentPoolMember>> GetPoolMembersAsync(int poolId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<TalentPoolMember>(
            "sp_TalentPool_GetMembers", new { TalentPoolId = poolId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<TalentPoolSummary>> GetPoolsForCandidateAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<TalentPoolSummary>(
            "sp_TalentPool_GetPoolsForCandidate", new { CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<CandidateSearchResult>> SearchAsync(CandidateSearchRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<CandidateSearchResult>(
            "sp_Candidate_Search",
            new
            {
                request.Keyword,
                request.MinExperience,
                request.MaxExperience,
                request.Location,
                request.Status,
                request.Source,
                request.Tag
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<int> SaveSearchAsync(int userId, SavedSearchRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_SavedSearch_Create",
            new
            {
                UserId = userId,
                request.Name,
                request.Keyword,
                request.MinExperience,
                request.MaxExperience,
                request.Location,
                request.Status,
                request.Source
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<SavedSearch>> GetSavedSearchesAsync(int userId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<SavedSearch>(
            "sp_SavedSearch_GetByUserId", new { UserId = userId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> DeleteSavedSearchAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_SavedSearch_Delete", new { Id = id }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }
}
