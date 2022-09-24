
CREATE proc  [ms].[MatchplayMatch2Upsert] 
	@leagueId int,
	@playround int,
	@vgcNo1 int,
	@vgcNo2 int
as
begin
	set nocount on
	 declare @t1 int, @t2 int, @season int  
	 declare @var nvarchar(100)
	 DECLARE @res TABLE
	(
		[PropertyId] [int] NOT NULL,
		[DataValue] [varchar](255) NULL,
		[SystemType] [varchar](50) NULL
	)

	---Other alternatives:---
	INSERT INTO @res([PropertyId],[DataValue],[SystemType])
	EXEC [ms].[PropertySelectById] @PropertyId=0
	select @season = cast([DataValue] as int) from @res

	SELECT @t1 = [LeagueTeamId]
	FROM [ms].[LeagueTeam]
	where @season = season and LeagueId = @LeagueId and @vgcNo1 = [VgcNo]
	if @t1 is null begin
		exec [ms].[LeagueTeamUpsert] @LeagueId, @VgcNo1 
		SELECT @t1 = [LeagueTeamId]
		FROM [ms].[LeagueTeam]
		where @season = season and LeagueId = @LeagueId and @vgcNo1 = [VgcNo]
	end

	SELECT @t2 = [LeagueTeamId]
	FROM [ms].[LeagueTeam]
	where @season = season and LeagueId = @LeagueId and @vgcNo2 = [VgcNo]
	if @t2 is null begin
		exec [ms].[LeagueTeamUpsert] @LeagueId, @VgcNo2 
		SELECT @t2 = [LeagueTeamId]
		FROM [ms].[LeagueTeam]
		where @season = season and LeagueId = @LeagueId and @vgcNo2 = [VgcNo]
	end

	declare @LeagueMatchId int
	exec [ms].[MatchplayMatchUpsert] @LeagueMatchId output, @LeagueId, @Playround ,@t1, @t2

	/*
	;WITH S as (
		select @leagueId as leagueId, @playround as playround, @t1 as t1, @t2 as t2
	) 
	MERGE [ms].[LeagueMatch] AS T
	USING S
		 ON S.[LeagueId] = T.[LeagueId]
		AND S.[PlayRound] = T.[PlayRound]
		AND S.t1 = T.[LeagueTeamId1]
		AND S.t2 = T.[LeagueTeamId2]
	WHEN MATCHED THEN UPDATE SET 
		[LeagueTeamId1] = S.t1,
		[LeagueTeamId2] = S.t2
	WHEN NOT MATCHED THEN INSERT
		([LeagueId], [PlayRound], [LeagueTeamId1], [LeagueTeamId2])
		VALUES (S.LeagueId, S.PlayRound, S.t1, S.t2);
		*/
end