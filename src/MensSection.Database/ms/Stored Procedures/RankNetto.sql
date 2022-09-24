
-- =============================================
-- Author:		Paul S
-- Create date: 16 okt., 2010
-- Description:	Finds the list of best scores (Netto) based on the @@MinCnt scores 
-- for each player. Only players how have @MinCnt scores are included
-- ex. EXEC ms.[RankNetto] '2016-01-01', '2017-01-01', 2
-- =============================================
CREATE PROCEDURE [ms].[RankNetto]
	@StartDate date,
	@EndDate date,
	@Cnt int,
	@MaxRounds int = 5
as
begin
	set nocount on
	;with  Collect(VgcNo, rn, Netto) as
	(
		SELECT VgcNo, 
			row_number() over(partition by VgcNo order by Netto asc) as rn, Netto + 72 - Par
		FROM ms.vMatchResult
		where MatchDate between @StartDate and @EndDate 
		and Netto is not null and Netto > 0
		and Official=1
	)
	,
	--select * from Collect
	CountMember(VgcNo, Cnt) as
	(
		select  VgcNo, count(Netto) as Cnt
		from Collect 
		group by VgcNo
	)
	--select * from CountMember
	,
	Limit(VgcNo, Netto) as
	(
		select  Collect.VgcNo, Netto
		from Collect inner join CountMember
		on Collect.VgcNo = CountMember.VgcNo
		where  Collect.rn <= @MaxRounds
		and CountMember.Cnt >= @Cnt
	)
	--select VgcNo, Netto from Limit
	,
	AvgNetto (VgcNo, Total, Res) as
	(
		select VgcNo, sum(Netto) as Total,  avg( convert(decimal,Netto)) as Res
		from Limit
		group by VgcNo
	)
	--select * from AvgNetto
	select Rank() over (order by Res, CountMember.Cnt ) as [Rank], AvgNetto.VgcNo, Firstname, Lastname, 
		convert(numeric(4,1), Res) as Netto,
		CountMember.Cnt
	from AvgNetto inner join ms.Player as p on
	AvgNetto.VgcNo = p.VgcNo
	inner join CountMember on
	AvgNetto.VgcNo = CountMember.VgcNo
	order by [Rank] Asc
end