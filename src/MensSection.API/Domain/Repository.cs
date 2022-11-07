using AutoMapper;
using Dapper;
using MensSection.API.Models;
using System.Data;
using System.Data.SqlClient;


namespace MensSection.API.Domain
{
    public class Repository : IRepository
    {
        private readonly IConfiguration _config;
        private readonly ILogger<Repository> _logger;
        private readonly IMapper _mapper;
 

        public Repository(IConfiguration config, ILogger<Repository> logger, IMapper mapper)
        {
            _config = config;
            _logger = logger;
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            SqlConnectionStringBuilder builder = new(ConnectionString);

            //foreach (System.Configuration.ConnectionStringSettings css in System.Configuration.ConfigurationManager.ConnectionStrings)
            //{
            //    logger.LogInformation(css.ConnectionString);
            //    // encryption part
            //    // rewriting the connectionString in the app.config or however you want ot be done 
            //}
            //if (System.Configuration.ConfigurationManager.ConnectionStrings["SqlDbConnectionString"] != null)
            //    connString = System.Configuration.ConfigurationManager.ConnectionStrings["SqlDbConnectionString"].ConnectionString;

            string connString = config.GetConnectionString("SqlDbConnectionString");
            _logger.LogInformation($"first read: {connString}");
            _logger.LogInformation(config.GetConnectionString("SqlDbConnectionString"));
            builder.ConnectionString = "Server=mssql1.unoeuro.com;Database=paulsweb_dk_db"; //  config.GetConnectionString("SqlDbConnectionString");
            builder.UserID = "paulsweb_dk"; // config["UserId"];
            builder.Password = "passiv"; // config["Password"];
            ConnectionString = builder.ConnectionString;
            logger.LogInformation($"Final : {ConnectionString}");
        }

        #region Database stuff
        private readonly string ConnectionString;

        private string? _database;
        /// <summary>
        /// Currently only used for information in API
        /// </summary>
        public string Database { 
            get {
                if (_database == null)
                {
                    using var con = new SqlConnection(ConnectionString);
                    _database = con.Database;
                }
                return _database;

            } 
        }

        public Dictionary<string, string> Info()
        {
            using var con = new SqlConnection(ConnectionString);
            Dictionary<string, string> dict = new()
            {
                { "Database", ConnectionString }
                //{ "Database", con.Database }
                //,
                //{ "Server", con.DataSource }
            };

            return dict;
        }

        public async Task<int> ExecuteCommand(string cmdText)
        {
            try
            {
                using var con = new SqlConnection(ConnectionString);
                using var cmd = con.CreateCommand();
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = cmdText;
                cmd.CommandTimeout = 240;

                con.Open();
                return await cmd.ExecuteNonQueryAsync();
            }
            catch (Exception e)
            {
                _logger.LogError($"ExecuteCommand({cmdText}) - {e.Message}");
                return 0;
            }
        }
        #endregion

        #region Club
        public async Task<Club?> GetClub(int id)
        {
            string sql = @"SELECT ClubId, ClubName "
                + "from ms.Club where ClubId = @id";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return (Club?)(await db.QueryAsync<Club>(sql, new { id })).FirstOrDefault();
        }

        public async Task<IEnumerable<Club>> GetClubs()
        {
            string sql = @"SELECT ClubId, ClubName FROM "
                + "ms.Club ORDER BY ClubName";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return (IEnumerable<Club>)(await db.QueryAsync<Club>(sql));
        }
        public async Task<Club> ClubUpsert(Club model)
        {
            using var con = new SqlConnection(ConnectionString);

            using var cmd = con.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "[ds].[ClubUpsert]";
            cmd.Parameters.AddWithValue("ClubId", model.ClubId).Direction = ParameterDirection.InputOutput;
            cmd.Parameters.AddWithValue("ClubName", model.ClubName);

            cmd.CommandTimeout = 240;
            con.Open();
            await cmd.ExecuteNonQueryAsync();

            model.ClubId = (int)cmd.Parameters["ClubId"].Value;
            return model;
        }

        #endregion

        #region Course

        public async Task<CourseInfo?> GetCourse(int id)
        {
            string sql = @"SELECT [CourseName]" +
                    ",[ClubId],[ClubName],[CourseId],[Slope],[CourseRating],[Par],[Tee]" +
                    ",[CourseTeeId],[CourseDetailId],[IsMale] " +
                    "FROM [ms].[vCourseInfo] " +
                    "where CourseDetailId = @id";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return (await db.QueryAsync<CourseInfo>(sql, new { id })).FirstOrDefault();
        }


        public async Task<IEnumerable<CourseInfo>> GetCourses(int clubId, int? courseId)
        {
            using var con = new SqlConnection(ConnectionString);

            string sql = @"SELECT [CourseName],[ClubId],[ClubName],[CourseId],
                            [Slope],[CourseRating],[Par],[Tee],
                            [CourseTeeId],[CourseDetailId],[IsMale]
                        FROM[ms].[vCourseInfo]
                        where IsMale = 1 and ClubId = @ClubId
                        and(@courseId is null or @courseId = courseId)
                        order by[CourseName], [Tee]";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return await db.QueryAsync<CourseInfo>(sql, new { clubId, courseId });
        }
        public async Task<CourseInfo> CourseUpsert(CourseInfo model)
        {
            using var con = new SqlConnection(ConnectionString);

            using var cmd = con.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "[ds].[CourseDetailUpsert]";
            cmd.Parameters.AddWithValue("CourseDetailId", model.CourseDetailId).Direction = ParameterDirection.InputOutput;
            cmd.Parameters.AddWithValue("CourseId", model.CourseId);
            cmd.Parameters.AddWithValue("CourseTeeId", model.CourseTeeId);
            cmd.Parameters.AddWithValue("Par", model.Par);
            cmd.Parameters.AddWithValue("CourseRating", model.CourseRating);
            cmd.Parameters.AddWithValue("Slope", model.Slope);

            cmd.CommandTimeout = 240;
            con.Open();
            await cmd.ExecuteNonQueryAsync();

            model.CourseDetailId = (int)cmd.Parameters["CourseDetailId"].Value;
            return model;
        }
        #endregion

        #region Tee
        public async Task<ListEntry?> GetTee(int teeId)
        {
            string sql = @"SELECT  [CourseTeeId] as [Key]
                    ,[Tee] as [Value] 
                    FROM [ms].[CourseTee]
                    where [CourseTeeId] = @teeId";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return (ListEntry?)(await db.QueryAsync<ListEntry>(sql, new { teeId }));
        }
        public async Task<IEnumerable<ListEntry>> GetTees()
        {
            string sql = @"SELECT  [CourseTeeId] as [Key]
                    ,[Tee] as [Value] 
                    FROM [ms].[CourseTee]";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return (IEnumerable<ListEntry>)(await db.QueryAsync<ListEntry>(sql));
        }
        public async Task<ListEntry> TeeUpsert(ListEntry model)
        {
            using var con = new SqlConnection(ConnectionString);

            using var cmd = con.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "[ds].[TeeUpsert]";
            cmd.Parameters.AddWithValue("CourseTeeId", model.Key).Direction = ParameterDirection.InputOutput;
            cmd.Parameters.AddWithValue("TeeName", model.Value);

            cmd.CommandTimeout = 240;
            con.Open();
            await cmd.ExecuteNonQueryAsync();

            model.Key = (int)cmd.Parameters["CourseTeeId"].Value;
            return model;
        }
        #endregion

        #region Match
        public async Task<Match?>GetMatch(int id)
        {
            string sql = @"select  
                [MatchId],[MatchDate],[MatchForm],[MatchText],[Sponsor],[SponsorLogoId],[CourseName]
                ,[Par],[Tee],[CourseRating],[Slope],[Remarks],[Official],[ClubName],[MatchformId]
                , [CourseDetailId],[MatchRowversion],[Shootout] 
                 from [ms].[vMatch] where MatchId = @id";

            using (IDbConnection db = new SqlConnection(ConnectionString))
            return (Match?)(await db.QueryAsync<Match>(sql, new { id })).FirstOrDefault();
        }
 
        public async Task<IEnumerable<Match>>GetMatchList()
        {
            string sql = @"select  
                [MatchId],[MatchDate],[MatchForm],[MatchText],[Sponsor],[SponsorLogoId],[CourseName]
                ,[Par],[Tee],[CourseRating],[Slope],[Remarks],[Official],[ClubName],[MatchformId]
                , [CourseDetailId],[MatchRowversion],[Shootout] 
                 from [ms].[vMatch]";

            using (IDbConnection db = new SqlConnection(ConnectionString))
            return (IEnumerable<Match>)(await db.QueryAsync<Match>(sql));
        }

        public async Task<IEnumerable<Match>>GetSeasonMatchList(int season)
        {
            string sql = @"select  
                [MatchId],[MatchDate],[MatchForm],[MatchText],[Sponsor],[SponsorLogoId],[CourseName]
                ,[Par],[Tee],[CourseRating],[Slope],[Remarks],[Official],[ClubName],[MatchformId]
                , [CourseDetailId],[MatchRowversion],[Shootout] 
                 from [ms].[vMatch] where Season  = @season";

            using (IDbConnection db = new SqlConnection(ConnectionString))
            return (IEnumerable<Match>)(await db.QueryAsync<Match>(sql, new { season }));
        }

        public async Task<Match> MatchUpsert(Match model)       
        {
            using var con = new SqlConnection(ConnectionString);

            using var cmd = con.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "[meta].[DatasetUpsert]";
            cmd.Parameters.AddWithValue("MatchId", model.MatchId).Direction = ParameterDirection.InputOutput;
            cmd.Parameters.AddWithValue("MatchDate", model.MatchDate);
            cmd.Parameters.AddWithValue("MatchformId", model.MatchformId);
            cmd.Parameters.AddWithValue("CourseDetailId", model.CourseDetailId);
            cmd.Parameters.AddWithValue("Par", model.Par);
            cmd.Parameters.AddWithValue("Description", model.MatchText);
            cmd.Parameters.AddWithValue("Sponsor", model.Sponsor);
            cmd.Parameters.AddWithValue("SponsorLogoId", model.SponsorLogoId);
            cmd.Parameters.AddWithValue("Remarks", model.Remarks);
            cmd.Parameters.AddWithValue("Official", model.Official);
            cmd.Parameters.AddWithValue("Shootout", model.Shootout);
            cmd.Parameters.AddWithValue("Official", model.Official);
            cmd.Parameters.AddWithValue("timestamp", model.timestamp);
               
            cmd.CommandTimeout = 240;
            con.Open();
            await cmd.ExecuteNonQueryAsync();

            model.MatchId = (int)cmd.Parameters["MatchId"].Value; 
            return model;
        }
        #endregion

        #region Player
        public async Task<IEnumerable<Player>> GetPlayers(int season)
        {
            DateTime start = new DateTime(season, 1, 1);
            string sql = @"SELECT [VgcNo],[FirstName],[LastName],[ZipCode],[City],[Address],[Email],
                [Sponsor],[Phone],[CellPhone],[HcpIndex],[Fee],[Insurance],[Season],[Eclectic],[HcpUpdated],
                [LastUpdate],[PlayerId],[MemberShipId], [NameGroup] 
                FROM ms.vPlayer 
                WHERE [Season]=@Season 
                ORDER BY [NameGroup], [LastName]";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return await db.QueryAsync<Player>(sql, new { season });
        }
        public async Task<Player?> GetPlayer(int vgcNo)
        {
            string sql = @"SELECT Top(1) [VgcNo],[FirstName],[LastName],[ZipCode],[City],[Address],[Email]," +
                "[Sponsor],[Phone],[CellPhone],[HcpIndex],[HcpUpdated]," +
                "[LastUpdate],[PlayerId] " +
                "FROM ms.Player where [vgcNo]=@vgcNo";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return (Player?)(await db.QueryAsync<Player>(sql, new { vgcNo })).FirstOrDefault();
        }
        //public async Task<Player?> GetPlayerByVgcNo(int vgcNo)
        //{
        //    string sql = @"SELECT Top(1) [VgcNo],[FirstName],[LastName],[ZipCode],[City],[Address],[Email]," +
        //        "[Sponsor],[Phone],[CellPhone],[HcpIndex],[HcpUpdated]," +
        //        "[LastUpdate],[PlayerId] " +
        //        "FROM ms.Player where vgcNo=@VgcNo";

        //    using (IDbConnection db = new SqlConnection(ConnectionString))
        //        return (Player?)(await db.QueryAsync<Player>(sql, new { vgcNo })).FirstOrDefault();
        //}


        public async Task<Player> PlayerUpsert(Player model)
        {
            using var con = new SqlConnection(ConnectionString);

            using var cmd = con.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "[dbo].[PlayerUpsert]";
            cmd.Parameters.AddWithValue("vgcNo", model.@VgcNo);
            cmd.Parameters.AddWithValue("Firstname", model.Firstname);
            cmd.Parameters.AddWithValue("Lastname", model.Lastname);
            cmd.Parameters.AddWithValue("ZipCode", model.ZipCode);
            cmd.Parameters.AddWithValue("City", model.City);
            cmd.Parameters.AddWithValue("Address", model.Address);
            cmd.Parameters.AddWithValue("Email", model.Email);
            cmd.Parameters.AddWithValue("Sponsor", model.Sponsor);
            cmd.Parameters.AddWithValue("Phone", model.Phone);
            cmd.Parameters.AddWithValue("HcpIndex", model.HcpIndex);

            cmd.CommandTimeout = 240;
            con.Open();
            await cmd.ExecuteNonQueryAsync();

            return model;
        }

        #endregion

        #region User
        public async Task<User?> GetUserByEmail(string email)
        {
            string sql = @"SELECT [Id],[Email],[PasswordHash],[PasswordSalt],[VerificationToken]
		                    ,[VerifiedAt],[PasswordRestToken],[ResetTokenExpires]
                            FROM [vgcms].[admin].[User] 
                            WHERE [email]=@email";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return (User?)(await db.QueryAsync<User?>(sql, new { email })).FirstOrDefault();
        }

        public async Task<User?> GetUserByToken(string token)
        {
            string sql = @"SELECT [Id],[Email],[PasswordHash],[PasswordSalt],[VerificationToken]
		                    ,[VerifiedAt],[PasswordRestToken],[ResetTokenExpires]
                            FROM [vgcms].[admin].[User] 
                            WHERE VerificationToken=@token";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return (User?)(await db.QueryAsync<User?>(sql, new { token })).FirstOrDefault();
        }

        public async Task<User?> GetUserByResetToken(string token)
        {
            string sql = @"SELECT [Id],[Email],[PasswordHash],[PasswordSalt],[VerificationToken]
		                    ,[VerifiedAt],[PasswordRestToken],[ResetTokenExpires]
                            FROM [vgcms].[admin].[User] 
                            WHERE PasswordRestToken=@token";

            using (IDbConnection db = new SqlConnection(ConnectionString))
                return (User?)(await db.QueryAsync<User?>(sql, new { token })).FirstOrDefault();
        }

        public async Task<User?> UserUpsert(User model)
        {
            using var con = new SqlConnection(ConnectionString);

            using var cmd = con.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "[admin].[UserUpsert]";
            cmd.Parameters.AddWithValue("Email", model.Email);
            cmd.Parameters.AddWithValue("PasswordHash", model.PasswordHash);
            cmd.Parameters.AddWithValue("PasswordSalt", model.PasswordSalt);
            cmd.Parameters.AddWithValue("VerificationToken", model.VerificationToken);
            cmd.Parameters.AddWithValue("VerifiedAt", model.VerifiedAt);
            cmd.Parameters.AddWithValue("PasswordResetToken", model.PasswordResetToken);
            cmd.Parameters.AddWithValue("ResetTokenExpires", model.ResetTokenExpires);

            cmd.CommandTimeout = 240;
            con.Open();
            await cmd.ExecuteNonQueryAsync();

            //model.CourseDetailId = (int)cmd.Parameters["CourseDetailId"].Value;
            return model;
        }
        #endregion

    }
}