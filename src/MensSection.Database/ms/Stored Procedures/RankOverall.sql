-- =============================================
-- Author:		Paul S
-- Create date: 6 jan., 2015
-- Description:	Finds all the overall winners
-- ex. EXEC ms.[RankOverall] '2015-01-01', '2016-01-01'
-- =============================================
 CREATE PROCEDURE [ms].[RankOverall]
	@StartDate datetime,
	@EndDate datetime
as
begin
	SET NOCOUNT ON;
	--declare	@StartDate datetime = '2015-01-01'
	--declare	@EndDate datetime = '2016-01-01'
	SELECT r.MatchDate, r.Firstname, r.Lastname, r.Points, r.VgcNo, 
		m.CourseName, m.ClubName, r.OverallWinner
	FROM ms.vMatchResult r INNER JOIN ms.vMatch m ON r.MatchId = m.MatchId
	WHERE r.MatchDate between @StartDate and @EndDate
		AND (r.OverallWinner = 1)
	ORDER BY r.MatchDate desc
end