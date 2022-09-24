--exec [ms].[ClubCourses] 28
Create procedure [ms].[ClubCourses]
	@clubId int,
	@courseId int = null
as
begin
	set nocount on;
	SELECT [CourseName],[ClubId],[ClubName],[CourseId],
		[Slope],[CourseRating],[Par],[Tee],
		[CourseTeeId],[CourseDetailId],[IsMale] 
	FROM [ms].[vCourseInfo]  
	where IsMale = 1 and ClubId = @ClubId 
	and (@courseId is null or @courseId = courseId )
	order by [CourseName], [Tee]
end