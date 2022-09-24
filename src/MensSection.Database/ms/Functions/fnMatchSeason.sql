CREATE function [ms].[fnMatchSeason](@season int)
returns table
AS
RETURN
	SELECT	MatchId, MatchDate, MatchForm, MatchformId, MatchText, 
			Sponsor, SponsorLogoId, CourseName, Par, Tee, CourseRating, 
			CourseDetailId, Slope, Remarks, Official, ClubName, 
			MatchRowversion, Shootout
	FROM	ms.vMatch
	WHERE	MatchDate BETWEEN DATEFROMPARTS(@season, 1, 1) 
							AND DATEFROMPARTS(@season + 2, 1, 1)