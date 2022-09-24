CREATE PROCEDURE [ms].[MatchResultSelectByStrokes]
	@MatchId int
as
begin
	SET NOCOUNT ON;

	declare @winner int
	SELECT top(1) @winner = MatchResultId
	FROM ms.vMatchResult 
	where MatchId=@MatchId 
	order by Dining desc, Netto desc;

	select MatchResultId, Puts, Brutto, Netto, Points, 
			Birdies, HcpIndex, MatchDate, Official, 
			[Rank], [No], 
			DamstahlPoints, Hcp, Lastname, Firstname, VgcNo, 
			HcpGroup, Dining, ShootOut  from 
	(
		SELECT MatchResultId, Puts, Brutto, Netto, Points, 
			Birdies, HcpIndex, MatchDate, Official, 
			0 as [Rank], 0 as [No], 
			DamstahlPoints, Hcp, Lastname, Firstname, VgcNo, 
			0 as HcpGroup, Dining, ShootOut 
		FROM ms.vMatchResult 
		where MatchResultId = @winner
		union
		SELECT MatchResultId, Puts, Brutto, Netto, Points, 
			Birdies, HcpIndex, MatchDate, Official, 
			rank() over  (Partition by HcpGroup order by Dining desc, Netto desc) as [Rank], 
			row_number() over  (Partition by HcpGroup order by Dining desc, Netto desc) as [No], 
			DamstahlPoints, Hcp, Lastname, Firstname, VgcNo, 
			HcpGroup, Dining, ShootOut 
		FROM ms.vMatchResult 
		where MatchId=@MatchId and MatchResultId <> @winner
	) as x
	order by HcpGroup, [No]
end