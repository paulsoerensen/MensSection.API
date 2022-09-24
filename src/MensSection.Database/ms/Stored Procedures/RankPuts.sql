
-- =============================================
-- Author:		Paul S
-- Create date: 16 okt., 2010
-- Description:	Finds the list of best scores (Put) based on the @@MinCnt scores 
-- for each player. Only players how have @MinCnt scores are included
-- ex. EXEC ms.[RankPuts] '2016-01-01', '2017-01-01', 2
-- =============================================
CREATE PROCEDURE [ms].[RankPuts]
	@StartDate date,
	@EndDate date,
	@Cnt int,
	@MaxRounds int = 5
as
begin
	set nocount on
	;with  Collect(VgcNo, rn, Puts) as
	(
		SELECT VgcNo, 
			row_number() over(partition by VgcNo order by Puts asc) as rn, Puts
		FROM ms.vMatchResult
		where MatchDate between @StartDate and @EndDate 
		and Official=1 and Puts is not null
	)
	,
	--select * from Collect
	CountMember(VgcNo, Cnt) as
	(
		select  VgcNo, count(Puts) as Cnt
		from Collect 
		group by VgcNo
	)
	--select * from CountMember
	,
	Limit(VgcNo, Puts) as
	(
		select  Collect.VgcNo, Puts
		from Collect inner join CountMember
		on Collect.VgcNo = CountMember.VgcNo
		where  Collect.rn <= @MaxRounds
		and CountMember.Cnt >= @Cnt
	)
	--select VgcNo, Puts from Limit
	,
	AvgPuts (VgcNo, Total, Res) as
	(
		select VgcNo, sum(Puts) as Total,  avg( convert(decimal,Puts)) as Res
		from Limit
		group by VgcNo
	)
	--select * from AvgPuts
	select Rank() over (order by Res) as [Rank], 
		AvgPuts.VgcNo, Firstname, Lastname, convert(numeric(4,1), Res) as Puts,  
		CountMember.Cnt
	from AvgPuts inner join ms.Player as p on
	AvgPuts.VgcNo = p.VgcNo
	inner join CountMember on
	AvgPuts.VgcNo = CountMember.VgcNo
	order by Res Asc, CountMember.Cnt asc
end