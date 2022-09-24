
create VIEW [ms].[vMatchResult]
AS
SELECT	r.MatchResultId, r.MatchId, r.MemberShipId, 
		m.MatchDate, m.MatchText, f.MatchForm, f.MatchformId, m.Official, m.Sponsor, m.SponsorLogoId, cb.ClubName, c.CourseName, 
		m.Par, t.Tee, p.VgcNo, p.Firstname, p.Lastname, r.HcpGroup, r.Hcp, r.HcpIndex, r.Brutto, r.Hallington, m.Shootout as MatchShootout,
		CASE WHEN f.MatchformId = 1 THEN r.Brutto - r.Hcp ELSE NULL END AS Netto, 
		r.Points, r.DamstahlPoints, r.Puts, r.Birdies, r.[Rank], r.Dining, r.ShootOut, r.OverallWinner, r.[timestamp]
FROM   ms.MatchResult AS r INNER JOIN
        ms.Match AS m ON r.MatchId = m.MatchId INNER JOIN
        ms.MemberShip AS s ON r.MemberShipId = s.MemberShipId INNER JOIN
        ms.Player AS p ON s.VgcNo = p.VgcNo INNER JOIN
        ms.CourseDetail AS d ON d.CourseDetailId = m.CourseDetailId INNER JOIN
        ms.Course AS c ON c.CourseId = d.CourseId INNER JOIN
        ms.Club AS cb ON cb.ClubId = c.ClubId INNER JOIN
        ms.CourseTee AS t ON d.CourseTeeId = t.CourseTeeId INNER JOIN
        ms.Matchform AS f ON f.MatchformId = m.MatchformId