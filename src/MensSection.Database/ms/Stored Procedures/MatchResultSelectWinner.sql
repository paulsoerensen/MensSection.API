CREATE PROCEDURE [ms].[MatchResultSelectWinner] 
	@matchId int
as
begin
	if exists (SELECT 1 FROM ms.vMatchResult where  MatchId=@matchId and OverallWinner=1) begin
		SELECT VgcNo, Firstname, Lastname, [Brutto], 
		case 
		when MatchformId = 1 then [Netto]
		when MatchformId = 3 then Hallington
		else null end as Netto, 
			DamStahlPoints, [Points] ,MatchId, [MatchResultId], 
			HcpIndex, Puts, Birdies, [Rank], Hcp, Shootout 
		FROM [ms].[vMatchResult] 
		where  MatchId=@matchId and OverallWinner=1
	end
end