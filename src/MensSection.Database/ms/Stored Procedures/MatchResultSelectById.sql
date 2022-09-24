CREATE PROC [ms].[MatchResultSelectById]
	@MatchResultId int
AS
BEGIN
	SELECT VgcNo, MemberShipId, MatchId, 
			HcpGroup, Hcp, 
			HcpIndex, Firstname, Lastname, 
			MatchResultId, Puts, Brutto,Netto, DamStahlPoints, 
			MatchformId, Points, Birdies, ShootOut, [Rank], Dining, [timestamp] 
	from ms.vMatchResult
	WHERE MatchResultId = @MatchResultId
END