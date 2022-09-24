-- =============================================
-- Author:		Paul S
-- Create date: 16 okt., 2010
-- Description:	Finds the list of best ds point based on the @MinCnt scores 
-- for each player. 
-- ex. EXEC ms.[RankDamstahl] '2015-01-01', '2016-01-01', 10
-- 2021-11-10 - simulator filtreres fra
-- =============================================
CREATE PROCEDURE [ms].[RankDamstahl]
	@StartDate datetime,
	@EndDate datetime,
	@CountingMatches int = 10
as
begin
	set nocount on

	declare @groupA int
	select @groupA = [ms].[HcpGroupBorder](SYSDATETIME());

	;with  Collect(VgcNo, rn, DamstahlPoints) as
	(
		SELECT VgcNo, 
			row_number() over(partition by VgcNo order by DamstahlPoints desc) as rn, 
			DamstahlPoints
		FROM ms.vMatchResult
		where MatchDate between @StartDate and @EndDate  and MatchformId != 8
			and Official=1
	)
	--select * from Collect
	,LimitRow(VgcNo, DamstahlPoints) as
	(
		select  VgcNo, DamstahlPoints
		from Collect 
		where rn <= @CountingMatches
	)
	,MinScore(VgcNo, DSMin) as
	(
		select  VgcNo, DamstahlPoints as DSMin
		from Collect 
		where rn = @CountingMatches
	)
	,AvgPts (VgcNo, Pts) as
	(
		select VgcNo, sum(DamstahlPoints) as Pts
		from LimitRow
		group by VgcNo
	)
	select Rank() over (order by Pts desc, IsNull(DSMin, 0)) as [Rank]
		,AvgPts.VgcNo, Firstname, Lastname, 
		ms.Hcpgroup( @groupA, p.HcpIndex) as HcpGroup,
		Pts as DamstahlTotal, IsNull(DSMin, 0) as DamstahlMin
	from AvgPts inner join ms.Player as p on
	AvgPts.VgcNo = p.VgcNo
	left join MinScore on 
	AvgPts.VgcNo = MinScore.VgcNo
	where Pts > 0
	order by [Rank] asc
end