-- =============================================
-- Author:		Paul S
-- Create date: 2016-04-15
-- Description:	Gets all data for result registration for a memeber
-- exec [ms].[MatchResultForMemberRegistration] 417, 1701
-- =============================================
CREATE PROCEDURE [ms].[MatchResultForMemberRegistration] 
	@MatchId int,
	@VgcNo int
	AS
Begin
	declare @Slope int
	declare @Par int
	declare @Cr numeric(3,1)
	declare @Season int
	declare @MatchformId int
	declare @DateOfEvent date

	select @Slope=Slope,@Par=c.Par, @Cr=CourseRating, @MatchformId = e.MatchformId,
	@Season= Datepart(year,MatchDate), @DateOfEvent=MatchDate
	from ms.Match as e inner join ms.CourseDetail as c
	on e.CourseDetailId=c.CourseDetailId
	where MatchId =@MatchId

	declare @groupA int
	select @groupA = [ms].[HcpGroupBorder](SYSDATETIME());
	;with cte as (
		SELECT VgcNo, MemberShipId, MatchId, @GroupA as MaxA, 
			@MatchformId as MatchformId,  HcpGroup, Hcp, 
			HcpIndex, FirstName, LastName, 
			MatchResultId, Puts, Brutto,Netto, DamStahlPoints, Hallington,
			Points, Birdies, ShootOut, Rank, Dining, [timestamp] 
		from ms.vMatchResult where MatchId = @MatchId and VgcNo=@VgcNo
		union
		SELECT VgcNo, MemberShipId, @MatchId as MatchId, @GroupA, 
			@MatchformId as MatchformId, ms.Hcpgroup( @groupA, HcpIndex),
			cast(round( @Slope*HcpIndex/113 + @Cr - @par, 0) as int) as Hcp, 
			HcpIndex, FirstName, LastName, 
			NULL as MatchResultId, NULL as Puts, NULL as Brutto, NULL as Netto, null as DamStahlPoints, null as Hallington,
			NULL as Points, NULL as Birdies, NULL as ShootOut, 1000 as Rank, 1 as Dining, NULL as [timestamp]
		FROM ms.vMembers
		where Season = @Season and VgcNo=@VgcNo and
			VgcNo not in 
		(select VgcNo from ms.vMatchResult where MatchId = @MatchId)
	)
	SELECT VgcNo, MemberShipId, MatchId, MaxA, 
		MatchformId, Hcpgroup,
		case when Hcp > 36 then 36 else Hcp end as Hcp,
		HcpIndex, FirstName, LastName, MatchResultId, Puts, Brutto, Netto, DamStahlPoints, Hallington,
		Points, Birdies, ShootOut, [Rank], Dining, [timestamp]
	from cte
	order by LastName, FirstName
end