using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for pre-joining checklists and hire-event handoff logging.</summary>
public sealed class PreJoiningRepository : IPreJoiningRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public PreJoiningRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<PreJoiningChecklist>> GetByCandidateIdAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<PreJoiningChecklist>(
            "sp_PreJoining_GetByCandidateId", new { CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<PreJoiningTask>> GetTasksAsync(int checklistId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<PreJoiningTask>(
            "sp_PreJoining_GetTasks", new { ChecklistId = checklistId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> SetJoiningDateAsync(int checklistId, DateTime joiningDate)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_PreJoining_SetJoiningDate", new { ChecklistId = checklistId, JoiningDate = joiningDate }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<bool> UpdateBgvStatusAsync(int checklistId, string bgvStatus)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_PreJoining_UpdateBgvStatus", new { ChecklistId = checklistId, BgvStatus = bgvStatus }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<int> AddTaskAsync(int checklistId, string taskName, int sortOrder)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_PreJoiningTask_Add", new { ChecklistId = checklistId, TaskName = taskName, SortOrder = sortOrder }, commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> ToggleTaskAsync(int id, bool isCompleted)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_PreJoiningTask_Toggle", new { Id = id, IsCompleted = isCompleted }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }

    public async Task<IEnumerable<HireEvent>> GetHireEventsByCandidateIdAsync(int candidateId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<HireEvent>(
            "sp_HireEvent_GetByCandidateId", new { CandidateId = candidateId }, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<HireEvent>> GetAllHireEventsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<HireEvent>("sp_HireEvent_GetAll", commandType: CommandType.StoredProcedure);
    }

    public async Task<bool> MarkHireEventSentAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var rows = await connection.ExecuteScalarAsync<int>(
            "sp_HireEvent_MarkSent", new { Id = id }, commandType: CommandType.StoredProcedure);
        return rows > 0;
    }
}
