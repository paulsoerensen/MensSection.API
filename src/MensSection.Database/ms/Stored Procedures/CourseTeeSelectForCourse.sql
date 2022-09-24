--exec [ms].[CourseTeeSelectForCourse] 169
CREATE procedure [ms].[CourseTeeSelectForCourse]
	@courseDetailId int
as
begin
	set nocount on;
	declare @courseId int
	select @courseId = c.[CourseId] 
	from ms.Course as c 
		inner join ms.CourseDetail as d 
			on c.CourseId = d.CourseId
	where [CourseDetailId] = 169

	SELECT t.CourseTeeId, t.Tee
	FROM	ms.CourseTee AS t 
				INNER JOIN ms.CourseDetail AS d 
					ON t.CourseTeeId = d.CourseTeeId 
				INNER JOIN
					ms.Course AS c ON d.CourseId = c.CourseId
	WHERE d.IsMale = 1 
	and c.CourseId = @courseId
	order by t.Tee
end