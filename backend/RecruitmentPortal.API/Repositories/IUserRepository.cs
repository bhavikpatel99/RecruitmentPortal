using RecruitmentPortal.API.Models;
using RecruitmentPortal.API.Models.DTOs;

namespace RecruitmentPortal.API.Repositories;

public interface IUserRepository
{
    Task<User?> GetByEmailAsync(string email);
    Task<User?> GetByIdAsync(int id);
    Task<int> CreateAsync(User user);
    Task<IEnumerable<UserSummaryDto>> GetAllAsync(string? role);
}
