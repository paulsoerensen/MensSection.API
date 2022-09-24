
-- =============================================
-- Author:		Paul S
-- Create date: 10 feb., 2017
-- Description:	Finds the neasrest pin
-- ex. EXEC ms.[RankNearestPin] '2016-01-01', '2017-01-01'
-- =============================================
create PROCEDURE [ms].[RankNearestPin]
	@StartDate date,
	@EndDate date
as
begin
	set nocount on
	SELECT [VgcNo]
		,[Firstname]
		,[Lastname]
		, Rank() over (order by [DistanceInCm]) as [Rank]
		,[PinName]
		,[DistanceInCm]
		,[MatchDate]
		,[CourseName]
	FROM [ms].[vNearestPin]
	where MatchDate between @StartDate and @EndDate 
	order by [DistanceInCm]
end