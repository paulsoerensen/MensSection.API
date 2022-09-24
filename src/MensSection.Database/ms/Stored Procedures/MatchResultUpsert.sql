
CREATE PROC [ms].[MatchResultUpsert]
	@MatchResultId int output,
	@vgcNo int,
	@MatchId int,
	@HcpIndex decimal(3,1),
	@Hcp int,
	@Puts int = NULL,
	@Brutto int = NULL,
	@Points int = NULL,
	@Hallington int = NULL,
	@Birdies int = NULL,
	@ShootOut int = NULL,
	@HcpGroup int, 
	@Dining bit, 
	@timestamp timestamp = null
AS
begin

	set nocount on
	declare @groupA int
	select @groupA = [ms].[HcpGroupBorder](SYSDATETIME());

	MERGE ms.MatchResult as T
	using (select @MatchResultId as MatchResultId, MemberShipId, @MatchId as MatchId
			, @Hcp as Hcp, @HcpIndex AS HcpIndex, @Puts as Puts, @Brutto as Brutto
			, @Points as Points, @Hallington as Hallington, @Birdies as Birdies
			, ms.Hcpgroup( @groupA, @HcpIndex) as HcpGroup
			, @Dining as Dining, @ShootOut as ShootOut
			from ms.vMembers where VgcNo = @vgcNo
	) as S
	on S.MatchResultId = T.MatchResultId
	when matched then update
		SET	Hcp = S.Hcp, HcpIndex = S.HcpIndex, Puts = S.Puts, Brutto = S.Brutto
		, Points = S.Points, Hallington = S.Hallington, Birdies = S.Birdies
		, HcpGroup = S.HcpGroup,
		Dining = S.Dining, ShootOut = S.ShootOut
	when not matched then insert (MemberShipId, MatchId
			, Hcp, HcpIndex, Puts, Brutto, Points, Hallington, Birdies
			, HcpGroup, Dining, ShootOut)
		values
			(S.MemberShipId, S.MatchId, S.Hcp, S.HcpIndex, S.Puts, S.Brutto, S.Points, 
				S.Hallington, S.Birdies, S.HcpGroup, S.Dining, S.ShootOut);

	IF COALESCE(@MatchResultId, 0) = 0 BEGIN
		SELECT @MatchResultId = CAST(SCOPE_IDENTITY() as [int]);
	END;
	set nocount off
end