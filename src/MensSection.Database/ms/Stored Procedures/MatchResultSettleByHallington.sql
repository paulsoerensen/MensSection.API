
create PROCEDURE [ms].[MatchResultSettleByHallington]
	@matchId int
as
begin
	if not exists(	SELECT 1 FROM ms.vMatch 
				where  MatchId=@matchId and MatchformId = 3) begin
		THROW 50000, N'Procedure can only be used for hallington', 1 
	end;

	update MatchResult set OverallWinner = 0 where MatchId=@matchId;
	
	-- find the winner
	declare @winner int =36
	SELECT top(1) @winner = MatchResultId
				FROM [ms].[vMatchResult] AS r 
				where r.MatchId=@matchId 
				order by Hallington desc, r.HcpIndex;
	update MatchResult set OverallWinner = 1 where MatchResultId = @winner;

	-- find and update the rank
	with cte as (            
		SELECT  MatchResultId
				,row_number() over  (Partition by HcpGroup order by Hallington desc, HcpIndex asc)+1 as [No]
					FROM [ms].[vMatchResult] AS r 
					where r.MatchId=@matchId and MatchResultId != @winner
					--der by Dining desc, [No], r.HcpIndex
		union 
		SELECT @winner, 1
	)
	update r 
	set Rank = no
	from ms.MatchResult as r inner join cte 
	on r.MatchResultId = cte.MatchResultId
end