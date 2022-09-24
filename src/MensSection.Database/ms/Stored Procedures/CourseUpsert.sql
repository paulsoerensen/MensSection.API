CREATE proc [ms].[CourseUpsert]
	@CourseId int output,
	@ClubId int,
	@CourseName varchar(50)
AS
BEGIN
	set nocount on

	if @CourseId < 1 begin
		SELECT @CourseId = CourseId	
		from Ms.Course
		where CourseName = @CourseName
	end

	Merge Ms.Course as T
	USING (SELECT
		@CourseId as CourseId,
		@ClubId as ClubId,
		@CourseName as CourseName)  AS S
	ON T.CourseId = S.CourseId
	When matched then update 
		SET T.ClubId = S.ClubId,
		T.CourseName = S.CourseName
	WHEN NOT MATCHED THEN INSERT 
				(ClubId, CourseName)
		VALUES (S.ClubId, S.CourseName);

	IF @CourseId < 1	BEGIN
		SELECT @CourseId = CAST(SCOPE_IDENTITY() as [int]);
	END;	
	set nocount off
END