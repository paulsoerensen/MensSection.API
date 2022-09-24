CREATE PROC [ms].[MatchSelectById]
	@MatchId int
AS
begin
	select  [MatchId],[MatchId] as MSEventId,[MatchDate],[MatchDate] as DateOfEvent,[MatchForm],[MatchText],[Sponsor],[SponsorLogoId],[CourseName]
		,[Par],[Tee],[CourseRating],[Slope],[Remarks],[Official],[ClubName],[MatchformId] 
		,[MatchRowversion]
		 from [ms].[vMatch] where MatchId = @MatchId
end