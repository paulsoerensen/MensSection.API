
-- =============================================
-- Author:		Paul S
-- Create date: 16 okt., 2010
-- Description:	Finds the list of best scores (Brutto) based on the @MinCnt scores 
-- for each player. Only players how have @MinCnt scores are included
-- ex. EXEC ms.[RankBrutto] '2016-01-01', '2017-01-01', 2
-- =============================================
 CREATE PROCEDURE [ms].[RankBrutto]
	@StartDate date,
	@EndDate date,
	@MinCnt int,
	@MaxRounds int = 5
as
begin
	set nocount on
	;with  Collect(VgcNo, rn, Brutto) as
	(
		SELECT VgcNo, 
			row_number() over(partition by VgcNo order by Brutto asc) as rn, Brutto + 72 - Par
		FROM ms.vMatchResult
		where MatchDate between @StartDate and @EndDate 
		and MatchformId = 1
		and Official=1
	)
	--select * from Collect
	,CountMember(VgcNo, Cnt) as
	(
		select  VgcNo, count(Brutto) as Cnt
		from Collect 
		group by VgcNo
	)
	--select * from CountMember
	,Limit(VgcNo, Brutto) as
	(
		select  Collect.VgcNo, Brutto
		from Collect inner join CountMember
		on Collect.VgcNo = CountMember.VgcNo
		where  Collect.rn <= @MaxRounds
		and CountMember.Cnt >= @MinCnt
	)
	--select VgcNo, Brutto from Limit
	,AvgBrutto (VgcNo, Res) as
	(
		select VgcNo, avg( convert(decimal,Brutto)) as Res
		from Limit
		group by VgcNo
	)
	--select * from AvgBrutto
	select Rank() over (order by Res, CountMember.Cnt ) as [Rank], 
		AvgBrutto.VgcNo, Firstname, Lastname, convert(numeric(4,1), Res) as Brutto,
		CountMember.Cnt
	from AvgBrutto inner join ms.Player as p on
	AvgBrutto.VgcNo = p.VgcNo
	inner join CountMember on
	AvgBrutto.VgcNo = CountMember.VgcNo
	order by [Rank]
end