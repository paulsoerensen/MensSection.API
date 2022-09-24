CREATE VIEW [ms].[vCourseInfo]
AS
SELECT        x.ClubId, x.ClubName, c.CourseName, c.CourseId, d.CourseDetailId, d.Slope, d.CourseRating, d.Par, t.CourseTeeId, t.Tee, d.IsMale
FROM            ms.CourseTee AS t INNER JOIN
                         ms.CourseDetail AS d ON t.CourseTeeId = d.CourseTeeId RIGHT OUTER JOIN
                         ms.Club AS x INNER JOIN
                         ms.Course AS c ON x.ClubId = c.ClubId ON d.CourseId = c.CourseId
WHERE        (d.IsMale = 1)