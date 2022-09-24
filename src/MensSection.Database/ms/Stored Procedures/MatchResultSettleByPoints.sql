
-- EXEC [dbo].[MatchResultSettleByPoints] @matchId = 453
create PROCEDURE [ms].[MatchResultSettleByPoints]
	@matchId int
as
begin
	if exists(	SELECT 1 FROM ms.vMatch 
				where  MatchId=@matchId and MatchformId = 1) begin
		THROW 50000, N'Procedure cannot be used for stroke play', 1 
	end;

	update MatchResult set OverallWinner = 0 where MatchId=@matchId;

	
	print 'Points'
	-- find the winner
	declare @winner int
	SELECT top(1) @winner = MatchResultId
				FROM [ms].[vMatchResult] AS r 
				where r.MatchId=@matchId 
				order by Points desc, r.HcpIndex;
	update ms.MatchResult set OverallWinner = 1 where MatchResultId = @winner;

	-- find and update the rank
	with cte as (            
		SELECT  MatchResultId
				,row_number() over  (Partition by HcpGroup order by Points desc, hcpIndex )+1 as [No]
					FROM [ms].[vMatchResult]AS r 
					where r.MatchId=@matchId and MatchResultId != @winner
					--der by Dining desc, [No], r.HcpIndex
		union 
		SELECT @winner, 1
	)
	update r 
	set [Rank] = no
	from ms.MatchResult as r inner join cte 
	on r.MatchResultId = cte.MatchResultId
end