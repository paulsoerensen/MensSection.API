-- =============================================
-- Author:		Paul S
-- Create date: 16 okt., 2010
-- Description:	Finds the list of best scores (Point) based on the @MinCnt scores 
-- for each player. 
-- ex. EXEC ms.[RankStableford] '2016-01-01', '2017-01-01'
-- 2021-11-10 - simulator filtreres fra
-- =============================================
CREATE PROCEDURE [ms].[RankStableford]
	@StartDate date,
	@EndDate date
as
begin
	set nocount on
	;with cto(VgcNo, Total, Cnt, Average) as
	(
		SELECT VgcNo, sum( [Points]) as Total, count( [Points]) as Cnt, AVG(Points) as Average
		FROM ms.vMatchResult
		where MatchDate between @StartDate and @EndDate and MatchformId != 8
		group by VgcNo
	)

	select Rank() over (order by Total desc, Cnt) as [Rank], 
		Firstname, Lastname, p.VgcNo, Total, Cnt, Average
	from ms.Player as p inner join cto 
	on p.VgcNo = cto.VgcNo
	Order by [Rank] 
end