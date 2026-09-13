using System.Data;
using Dapper;
using RecruitmentPortal.API.Data;
using RecruitmentPortal.API.Models;

namespace RecruitmentPortal.API.Repositories;

/// <summary>Stored-procedure-based data access for the lookup tables that drive the form dropdowns.</summary>
public sealed class LookupRepository : ILookupRepository
{
    private readonly IDbConnectionFactory _connectionFactory;

    public LookupRepository(IDbConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<Country>> GetCountriesAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<Country>(
            "sp_Lookup_GetCountries",
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<StateItem>> GetStatesAsync(int countryId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<StateItem>(
            "sp_Lookup_GetStates",
            new { CountryId = countryId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<string>> GetLookupValuesAsync(string category)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<string>(
            "sp_Lookup_GetValuesByCategory",
            new { Category = category },
            commandType: CommandType.StoredProcedure);
    }
}
