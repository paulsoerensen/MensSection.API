

CREATE VIEW [ms].[vCourse] AS 
SELECT  x.ClubId, x.ClubName, c.CourseName, c.CourseId  
FROM   ms.Club as x 
		 INNER JOIN ms.Course AS c 
			ON x.ClubId = c.ClubId