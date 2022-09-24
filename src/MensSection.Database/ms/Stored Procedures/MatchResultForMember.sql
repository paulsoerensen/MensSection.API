/*
	EXECUTE [ms].[MatchResultForMember] '2016-01-01', '2017-01-01', 1701
*/
CREATE PROC [ms].[MatchResultForMember]
	@StartDate datetime,
	@EndDate datetime,
	@VgcNo int
AS
begin
	declare @newEndDate datetime
	set @newEndDate = dateadd(hh, -10, getdate());
	if @EndDate > @newEndDate begin
		set @EndDate = @newEndDate
	end

	SELECT r.VgcNo, r.Firstname, r.Lastname, r.MatchDate, r.MatchForm, r.Brutto, r.Hcp, 
	r.HcpIndex, r.Netto, r.Points, r.Hallington, r.Shootout, r.Par, r.Tee, e.MatchId,  
	r.DamstahlPoints, r.Birdies, r.Puts, c.CourseName
	,cb.ClubName, r.Official
	FROM   ms.vMatchResult r INNER JOIN
	       ms.Match e ON r.MatchId = e.MatchId INNER JOIN
	       ms.CourseDetail cd ON e.CourseDetailId = cd.CourseDetailId INNER JOIN
	       ms.Course c ON c.CourseId = cd.CourseId  
		   INNER JOIN ms.Club AS cb ON cb.ClubId = c.ClubId
	WHERE VgcNo=@VgcNo
		and r.MatchDate between @StartDate and @EndDate 
	ORDER BY r.MatchDate desc
end