CREATE PROC [ms].[MatchResultSelectDates]
	@StartDate datetime,
	@EndDate datetime
AS
begin
	declare @newEndDate datetime
	set @newEndDate = dateadd(hh, 0, getdate());
	--set @newEndDate = dateadd(hh, -10, getdate());
	if @EndDate > @newEndDate begin
		set @EndDate = @newEndDate
	end
	SELECT  distinct e.MatchId as [Key], e.MatchDate as [Value]
	FROM   ms.Match e INNER JOIN
	       ms.MatchResult r ON e.MatchId = r.MatchId
	WHERE  e.MatchDate between @StartDate and @EndDate 
	ORDER BY e.MatchDate desc
end