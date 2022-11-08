using MensSection.Api.Models;


namespace MensSection.Api.Domain;

public interface IRepository
{
    public Dictionary<string, string> Info();

    #region Club
    Task<Club?> GetClub(int id);
    Task<IEnumerable<Club>> GetClubs();
    Task<Club> ClubUpsert(Club model);
    #endregion

    #region Course
    Task<CourseInfo?> GetCourse(int courseId);
    Task<IEnumerable<CourseInfo>> GetCourses(int clubId, int? courseId);
    Task<CourseInfo> CourseUpsert(CourseInfo model);
    #endregion

    #region Tee
    Task<ListEntry?> GetTee(int teeId);
    Task<IEnumerable<ListEntry>> GetTees();
    Task<ListEntry> TeeUpsert(ListEntry model);
    #endregion

    #region Match
    Task<Match?> GetMatch(int matchId);
    Task<IEnumerable<Match>> GetMatchList();
    Task<IEnumerable<Match>> GetSeasonMatchList(int season);
    Task<Match> MatchUpsert(Match dto);
    #endregion

    #region Player
    Task<IEnumerable<Player>> GetPlayers(int season);
    Task<Player?> GetPlayer(int playerId);
    Task<Player> PlayerUpsert(Player model);
    #endregion

    #region User
    Task<User?> UserUpsert(User model);
    Task<User?> GetUserByEmail(string email);
    Task<User?> GetUserByToken(string token);
    Task<User?> GetUserByResetToken(string token);
    #endregion
}
