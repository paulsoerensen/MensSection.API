CREATE VIEW [ms].[vLeagueTeam]
AS
SELECT l.LeagueId, l.LeagueName, l.Single, t.LeagueTeamId, t.Season, t.TeamName, t.VgcNo, t.VgcNoPartner
FROM   ms.LeagueTeam AS t INNER JOIN ms.League AS l ON t.LeagueId = l.LeagueId