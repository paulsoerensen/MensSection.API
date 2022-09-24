-- =============================================
-- Author:		Paul S
-- Create date: 16 apr., 2012
-- Description:	Finds the list of best scores (ShootOut) based on the @@MinCnt scores 
-- for each player. Only players how have @MinCnt scores are included
-- ex. EXEC ms.[RankShootOut] '2015-01-01', '2016-01-01'
-- =============================================
CREATE PROCEDURE [ms].[RankShootOut]
	@StartDate date,
	@EndDate date
as
begin
	set nocount on
	;with  Collect(VgcNo, rn, ShootOut) as
	(
		SELECT VgcNo, 
			row_number() over(partition by VgcNo order by ShootOut desc) as rn, ShootOut
		FROM ms.vMatchResult
		where MatchDate between @StartDate and @EndDate and MatchShootout = 1 
		and Official=1
	)
	--select * from Collect
	,CountMember(VgcNo, Cnt) as
	(
		select  VgcNo, count(ShootOut) as Cnt
		from Collect 
		group by VgcNo
	)
	--select * from CountMember
	,Limit(VgcNo, ShootOut, x, y) as
	(
		select  Collect.VgcNo, ShootOut,  Collect.rn, CountMember.Cnt 
		from Collect inner join CountMember
		on Collect.VgcNo = CountMember.VgcNo
		where Collect.rn <= 7
	)
	--select * from Limit
	,ShootOut (VgcNo, Total) as
	(
		select VgcNo, sum(ShootOut) as Total
		from Limit
		group by VgcNo
	)
	--select * from ShootOut
	select Rank() over (order by Total desc, Cnt) as [Rank], 
		ShootOut.VgcNo, Firstname, Lastname, Total as Points,  
		CountMember.Cnt
	from ShootOut inner join ms.Player as p on
	ShootOut.VgcNo = p.VgcNo
	inner join CountMember on
	ShootOut.VgcNo = CountMember.VgcNo
	order by Points desc, CountMember.Cnt asc
end