
CREATE VIEW [ms].[vNearestPin]
AS
SELECT        p.VgcNo, p.Firstname, p.Lastname, n.NearestPinId, n.MemberShipId, n.MatchId, n.PinName, n.DistanceInCm, m.MatchDate, c.CourseName
FROM            ms.NearestPin AS n INNER JOIN
                         ms.MemberShip AS s ON n.MemberShipId = s.MemberShipId INNER JOIN
                         ms.Player AS p ON s.VgcNo = p.VgcNo INNER JOIN
                         ms.Match AS m ON n.MatchId = m.MatchId INNER JOIN
                         ms.CourseDetail AS d ON m.CourseDetailId = d.CourseDetailId INNER JOIN
                         ms.Course AS c ON d.CourseId = c.CourseId