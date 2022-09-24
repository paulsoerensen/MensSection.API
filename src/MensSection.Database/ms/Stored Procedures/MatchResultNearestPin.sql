CREATE PROCEDURE [ms].[MatchResultNearestPin] 
	@matchId int
as
begin
	set nocount on
	SELECT [VgcNo],[Firstname],[Lastname],[NearestPinId]
		,[MemberShipId],[MatchId],[PinName],[CourseName],[DistanceInCm],[MatchDate] 
		FROM [ms].[vNearestPin]
		where MatchId = @MatchId 
end