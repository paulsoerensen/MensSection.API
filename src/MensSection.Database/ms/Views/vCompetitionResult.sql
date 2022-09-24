

CREATE VIEW [ms].[vCompetitionResult]
AS
SELECT        m.MatchDate, c.CompetitionText, c.ListOrder, r.CompetitionResultId, r.MembershipId, r.CompetitionId, p.VgcNo, p.Firstname, p.Lastname, r.MatchId
FROM            ms.Competition AS c INNER JOIN
                         ms.CompetitionResult AS r ON c.CompetitionId = r.CompetitionId INNER JOIN
                         ms.Match AS m ON r.MatchId = m.MatchId INNER JOIN
                         ms.MemberShip AS s ON r.MembershipId = s.MemberShipId INNER JOIN
                         ms.Player AS p ON s.VgcNo = p.VgcNo