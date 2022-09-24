

CREATE proc  [ms].[CourseDetailUpsert]
	@CourseDetailId int output,
	@CourseId int,
	@CourseTeeId int,
	@Par int,
	@CourseRating decimal(3,1),
	@Slope int
as
begin
	merge ms.CourseDetail as T 
	using (select @CourseDetailId as CourseDetailId
			,@CourseId as CourseId  
			,@CourseTeeId as CourseTeeId  
			,@Par as Par  
			,@CourseRating as CourseRating 
			,@Slope as Slope  
	) as S
	on S.CourseDetailId = T.CourseDetailId
	when matched then update set 
			CourseId = @CourseId  
			,CourseTeeId = @CourseTeeId  
			,Par = @Par  
			,CourseRating = @CourseRating 
			,Slope = @Slope  
	when not matched then insert 
		([CourseId]
           ,[CourseTeeId]
           ,[IsMale]
           ,[Par]
           ,[CourseRating]
           ,[Slope])
		VALUES (@CourseId,@CourseTeeId, 1,@Par,@CourseRating,@Slope);

	IF @CourseDetailId IS NULL OR @CourseDetailId = 0 BEGIN
		SELECT @CourseDetailId = CAST(SCOPE_IDENTITY() as [int]);
	END;

	set nocount on
end