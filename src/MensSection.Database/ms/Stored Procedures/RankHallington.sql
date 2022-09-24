
-- =============================================
-- Author:		Paul S
-- Create date: 16 okt., 2010
-- Description:	Finds the list of best scores (Hallington) based on the @@MinCnt scores 
-- for each player. Only players how have @MinCnt scores are included
-- ex. EXEC ms.[RankHallington] '2015-01-01', '2016-01-01', 5
-- =============================================
CREATE PROCEDURE [ms].[RankHallington]
	@StartDate datetime,
	@EndDate datetime,
	@Cnt int = 5
as 
BEGIN
 --   declare	@StartDate datetime = '2020-01-01'
	--declare	@EndDate datetime = '2021-01-01'
	--declare	@Cnt int = 5

	;with Collect(VgcNo, score) as
	(
		SELECT VgcNo, Hallington+72-par
		FROM ms.vMatchResult
		where MatchDate between @StartDate and @EndDate
		--and MatchDate > '2018-05-01' 
		and Hallington is not null and Hallington > 0
		and Official=1
		and MatchformId = 3  -- Hallington
	)
	--select * from Collect order by VgcNo
	,CollectRank(VgcNo, rn, score, Cnt, dev) as
	(
		SELECT VgcNo, 
			row_number() over(partition by VgcNo order by score desc) as rn, score,
			count(*) over (partition by VgcNo) as cnt, score
		FROM Collect
	)
	--select * from CollectRank order by VgcNo

	,Limit(VgcNo, score, Cnt) as
	(
		select VgcNo, score, Cnt
		from CollectRank 
		where  1 = 1 
		--and rn <= 5
		and Cnt >= @Cnt
	)
	--select VgcNo, score, Cnt from Limit  order by VgcNo
	,AvgNetto (VgcNo, Total, res) as
	(
		select VgcNo, sum(score) as Total,  avg( convert(decimal,score)) as Res
		from Limit
		group by VgcNo
	)
	--select * from AvgNetto  order by VgcNo
	,cte (VgcNo, Firstname, Lastname, score, Cnt, HcpIndex) as
	(
		select distinct AvgNetto.VgcNo, Firstname, Lastname, convert(numeric(4,1), res) as score, Cnt, p.HcpIndex
		from AvgNetto inner join ms.Player as p on
		AvgNetto.VgcNo = p.VgcNo
		inner join Limit on
		Limit.VgcNo = p.VgcNo
	)
	select VgcNo, Firstname, Lastname, Score, Cnt,
		rank() over (order by score desc) as [Rank] 
	from cte 
	order by Score desc, Cnt asc, HcpIndex
end