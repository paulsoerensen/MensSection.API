-- =============================================
-- Author:		Paul S
-- Create date: 2016-04-15
-- Description:	Select a list of all results for a given event - registrered and not-registrered
--              Extra specifies possible extra empty entries used in reports
-- exec [ms].[MatchResultListForRegistration] 495, 10
-- =============================================
CREATE PROCEDURE [ms].[MatchResultListForRegistration] 
	@MatchId int,
	@Extra int = 0
AS
Begin
	declare @Slope int
	declare @Par int
	declare @Cr numeric(3,1)
	declare @Season int
	declare @MatchformId int
	declare @DateOfEvent date

	select @Slope=Slope,@Par=c.Par, @Cr=CourseRating, @MatchformId = e.MatchformId,
	@Season= Datepart(year,MatchDate), @DateOfEvent=CAST(MatchDate AS DATE)
	from ms.Match as e inner join ms.CourseDetail as c
	on e.CourseDetailId=c.CourseDetailId
	where MatchId =@MatchId

	declare @groupA int
	select @groupA = [ms].[HcpGroupBorder](SYSDATETIME());

	;with cte as (
		SELECT top(@Extra) null as VgcNo,MemberShipId, 0 as MatchId, 0 as MaxA, 
			@MatchformId as MatchformId, null as HcpGroup, null as Hcp, 
			null as HcpIndex, null as FirstName, null as LastName, 
			MatchResultId, Puts, Brutto,Netto, DamStahlPoints, 
			Points, Birdies, ShootOut, Rank, Dining, [timestamp] 
		from vMatchResult where MatchId < @MatchId and Datepart(year,MatchDate) = @Season 
		union
		SELECT VgcNo, MemberShipId, MatchId, @GroupA as MaxA, 
			@MatchformId as MatchformId, HcpGroup, Hcp, 
			HcpIndex, FirstName, LastName, MatchResultId, Puts, Brutto,Netto, DamStahlPoints, 
			Points, Birdies, ShootOut, Rank, Dining, [timestamp] 
		from ms.vMatchResult where MatchId = @MatchId 
		union
		SELECT VgcNo, MemberShipId, @MatchId as MatchId, @GroupA,
			@MatchformId as MatchformId, ms.Hcpgroup( @groupA, HcpIndex),
			cast(round( @Slope*HcpIndex/113 + @Cr - @par, 0) as int) as Hcp, 
			HcpIndex, FirstName, LastName, 
			NULL as MSResultatId, NULL as Put, NULL as Brutto, NULL as Netto, null as DamStahlPoints, 
			NULL as Points, NULL as Birdies, NULL as ShootOut, 1000 as Rank, 1 as Dining, null as [timestamp] 
		FROM ms.vMembers
		where Season = @Season and VgcNo not in 
		(select VgcNo from vMatchResult where MatchId = @MatchId)
	)
	SELECT VgcNo,MemberShipId, MatchId, MaxA, 
			MatchformId, HcpGroup, 
			case when Hcp > 36 then 36 else Hcp end as Hcp,
			HcpIndex, FirstName, LastName, 
			MatchResultId, Puts, Brutto,Netto, DamStahlPoints, 
			Points, Birdies, ShootOut, [Rank], Dining, [timestamp] 
	from cte
	order by LastName, FirstName
end