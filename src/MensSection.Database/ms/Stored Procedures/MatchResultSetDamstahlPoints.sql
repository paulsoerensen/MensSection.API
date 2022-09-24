create PROCEDURE [ms].[MatchResultSetDamstahlPoints]
	@matchId int
as
begin
	-- set the Damstahl according to the rank
	update ms.MatchResult 
	set DamstahlPoints = 
		case 
			when Rank = 1 then 8
			when Rank  < 3 then 6
			when Rank  < 6 then 5
			when Rank  < 9 then 4
			when Rank  < 12 then 3
			when Rank  < 14 then 2
			else 0
		end
	where matchId = @matchId

	-- give 1 point up to the median for the rest
	;with cte as (
		SELECT MatchResultId, HcpGroup, DamstahlPoints
		 ,(COUNT(*) OVER (Partition by MatchId, HcpGroup)+1)/ 2 AS Cnt
		FROM ms.MatchResult
		where MatchId=@matchId
	)
	update r 
	set DamstahlPoints = 1
	from ms.MatchResult as r inner join cte 
	on r.MatchResultId = cte.MatchResultId
	where cte.DamstahlPoints = 0 and [Rank] < = Cnt
end