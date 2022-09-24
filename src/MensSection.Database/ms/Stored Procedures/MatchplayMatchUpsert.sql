CREATE proc  [ms].[MatchplayMatchUpsert] 
	@LeagueMatchId int output,
	@LeagueId int,
	@Playround int,
	@LeagueTeamId1 int,
	@LeagueTeamId2 int
as
 begin
	set nocount on
	if not exists(	select 1 
					from ms.LeagueTeam 
					where LeagueTeamId = @LeagueTeamId1 
						and LeagueId = @LeagueId)
	begin
		;THROW 99001, '1. Team does not exist in league', 1; 
	end
	if not exists(select 1 
					from ms.LeagueTeam 
					where LeagueTeamId = @LeagueTeamId2 
						and LeagueId = @LeagueId)
	begin
		;THROW 99001, '2. Team does not exist in league', 1; 
	end

	if coalesce(@LeagueMatchId, 0) = 0 AND  @Playround > 1 begin
		if @LeagueTeamId1 in  
		(
			select LeagueTeamId1 from ms.LeagueMatch where LeagueId = @LeagueId and Playround = @Playround
			union
			select LeagueTeamId2 from ms.LeagueMatch where LeagueId = @LeagueId and Playround = @Playround
		) begin
			;THROW 99001, '1. Team already in match', 1; 
		end
		if @LeagueTeamId2 in  
		(
			select LeagueTeamId1 from ms.LeagueMatch where LeagueId = @LeagueId and Playround = @Playround
			union
			select LeagueTeamId2 from ms.LeagueMatch where LeagueId = @LeagueId and Playround = @Playround
		) begin
			;THROW 99001, '2. Team already in match', 1; 
		end
	end

	if @LeagueTeamId2 < @LeagueTeamId1 begin
		declare @i int = @LeagueTeamId1
		set @LeagueTeamId1 = @LeagueTeamId2
		set @LeagueTeamId2 = @i
	end

	MERGE ms.LeagueMatch as T 
	USING (select
		@LeagueMatchId as LeagueMatchId, 
		@LeagueId 	   as LeagueId, 
		@Playround 	   as Playround, 
		@LeagueTeamId1 as LeagueTeamId1, 
		@LeagueTeamId2 as LeagueTeamId2 
	) as S
	on T.LeagueMatchId  = S.LeagueMatchId
	WHEN MATCHED then UPDATE set 
		T.LeagueId = S.LeagueId, 
		T.Playround = S.Playround,
		T.LeagueTeamId1 =S.LeagueTeamId1,
		T.LeagueTeamId2 = S.LeagueTeamId2, 
		T.LastUpdate = SYSDATETIME()
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (LeagueId,Playround,LeagueTeamId1,LeagueTeamId2)
			values (S.LeagueId, S.Playround, S.LeagueTeamId1, S.LeagueTeamId2);

	IF @LeagueMatchId IS NULL OR @LeagueMatchId = 0 BEGIN
		SELECT @LeagueMatchId = CAST(SCOPE_IDENTITY() as [int]);
	END;

	set nocount on
end