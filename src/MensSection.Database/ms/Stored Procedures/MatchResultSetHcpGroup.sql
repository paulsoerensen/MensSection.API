----------------------------------------------------------------------------
-- Select a list of all results for a given event - registrered and not-registrered
--exec [dbo].[MatchResultSetHcpGroup] 417
----------------------------------------------------------------------------
CREATE procedure [ms].[MatchResultSetHcpGroup] 
	@MatchId int
AS
Begin
	declare @Slope int
	declare @Par int
	declare @Cr numeric(3,1)

	declare @groupA int
	select @groupA = [ms].[HcpGroupBorder](SYSDATETIME());

	select @Slope=Slope,@Par=c.Par, @Cr=CourseRating 
	from ms.Match as e inner join ms.CourseDetail as c
	on e.CourseDetailId=c.CourseDetailId
	where MatchId =@MatchId

	update ms.MatchResult
	Set Hcp = cast(round( @Slope*HcpIndex/113 + @Cr - @par, 0) as int)
	where MatchId = @MatchId

	update ms.MatchResult
	Set HcpGroup = ms.Hcpgroup( @groupA, HcpIndex)
	where MatchId = @MatchId
end