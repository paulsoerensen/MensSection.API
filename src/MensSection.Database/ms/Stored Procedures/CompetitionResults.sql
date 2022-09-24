Create PROCEDURE [ms].[CompetitionResults] 
	@matchId int
as
begin
	set nocount on
	SELECT [MatchDate],[CompetitionText] 
		,[CompetitionResultId],[MembershipId],[CompetitionId] 
		,[VgcNo],[Firstname],[Lastname],[MatchId] 
	 FROM [ms].[vCompetitionResult] 
	 WHERE MatchId = @matchId
	 order by listorder
end