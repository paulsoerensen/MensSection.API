
-- =============================================
-- Author:		Paul S
-- Create date: 21 jan., 2017
-- Description:	Finds the list of best scores (Birdies) based on the @@MinCnt scores 
-- for each player. Only players how have @MinCnt scores are included
-- ex. EXEC ms.[RankBirdies] '2016-01-01', '2017-01-01', 2
-- =============================================
CREATE PROCEDURE [ms].[RankBirdies]
	@StartDate date,
	@EndDate date,
	@Cnt int,
	@MaxRounds int = 5
as
begin
	set nocount on
	;with  Collect(VgcNo, cnt, Birdies) as
	(
		select VgcNo, COUNT(*) as cnt, Sum(Birdies) as Birdies
		FROM ms.vMatchResult
		where MatchDate between @StartDate and @EndDate 
		and Official=1 and Birdies is not null
		group by vgcno
		having COUNT(*) >= @Cnt
		--and VgcNo = 1701
	)
	select Rank() over (order by birdies desc, cnt asc) as [Rank], 
		c.VgcNo, Firstname, Lastname, Birdies, Cnt
	from Collect as c inner join ms.Player as p on
	c.VgcNo = p.VgcNo
	where Birdies > 0
	order by [Rank] asc, Birdies, Cnt asc
end