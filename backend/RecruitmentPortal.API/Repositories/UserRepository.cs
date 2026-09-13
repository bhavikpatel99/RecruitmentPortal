using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for dbo.Users.</summary>
public sealed class UserRepository : IUserRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public UserRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<User?> GetByEmailAsync(string email)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<User>(
            "sp_User_GetByEmail",
            new { Email = email },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<User?> GetByIdAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<User>(
            "sp_User_GetById",
            new { Id = id },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateAsync(User user)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<int>(
            "sp_User_Create",
            new { user.FullName, user.Email, user.PasswordHash, user.Role },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<UserSummaryDto>> GetAllAsync(string? role)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<UserSummaryDto>(
            "sp_User_GetAll",
            new { Role = role },
            commandType: CommandType.StoredProcedure);
    }
}
