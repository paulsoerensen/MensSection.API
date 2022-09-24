-- =============================================
-- Author:		Paul S
-- Create date: 11 nov., 2021
-- Description:	Finds the list of best sum of 5 scores
-- for each player. 
-- ex. EXEC ms.[RankSimulator] '2021-01-01', '2022-01-01'
-- =============================================
CREATE PROCEDURE [ms].[RankSimulator]
	@StartDate date,
	@EndDate date
as
begin
	set nocount on
	;with cto as
	(
		SELECT VgcNo, row_number() over (partition by vgcNo order by [Points] desc) as rnk, [Points]
		--sum( [Points]) as Total, count( [Points]) as Cnt, AVG(Points) as Average
		FROM ms.vMatchResult
		where MatchDate between @StartDate and @EndDate and MatchformId = 8
		--group by VgcNo
	)
	, cte as (
		select vgcno, sum(points) as total, avg(points) as Average, max(rnk) as cnt
		from cto 
		where rnk < 6
		group by vgcno
	)
	select Rank() over (order by Total desc, Cnt) as [Rank], 
		Firstname, Lastname, p.VgcNo, Total, Cnt, Average
	from ms.Player as p inner join cte 
	on p.VgcNo = cte.VgcNo
	order by total desc, Cnt desc
end