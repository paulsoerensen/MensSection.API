
CREATE PROCEDURE [ms].[MatchResultSettleByStroke]
	@matchId int
as
begin
	if not exists(	SELECT 1 FROM ms.vMatch 
				where  MatchId=@matchId and MatchformId = 1) begin
		THROW 50000, N'Procedure can only be used for stroke play', 1 
	end;

	update MatchResult set OverallWinner = 0 where MatchId=@matchId;
	
	-- find the winner
	declare @winner int =-1
	SELECT top(1) @winner = MatchResultId
				FROM [ms].[vMatchResult] AS r 
				where r.MatchId=@matchId 
				order by Netto asc, r.HcpIndex;
	update MatchResult set OverallWinner = 1 where MatchResultId = @winner;

	-- find and update the rank
	with cte as (            
		SELECT  MatchResultId
				,row_number() over  (Partition by HcpGroup order by Netto asc, HcpIndex asc)+1 as [No]
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