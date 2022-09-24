
CREATE PROCEDURE [ms].[MatchResultRanking]
	@matchId int
as
begin
	declare @formId int = -1
	select @formId = MatchFormId, @matchId = MatchId
	from ms.Match
	where MatchId = @matchId

	if @formId = 1 begin
		exec [MatchResultRankByStroke] @matchId
	end 
	else if @formId = 3 begin
		print 'Hallington'
		exec [MatchResultRankByHallington] @matchId
	end 
	else begin
		exec [MatchResultRankByPoints] @matchId
	end 
	exec MatchResultSetDamstahlPoints @matchId
end