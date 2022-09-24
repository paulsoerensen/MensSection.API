


CREATE VIEW [ms].[vTee] AS 
SELECT  d.CourseId  
		,d.CourseDetailId, t.Tee
FROM    ms.CourseTee AS t INNER JOIN ms.CourseDetail AS d 
			ON t.CourseTeeId = d.CourseTeeId 
where d.IsMale=1