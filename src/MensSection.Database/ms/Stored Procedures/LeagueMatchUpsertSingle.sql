
CREATE proc  [ms].[LeagueMatchUpsertSingle] 
	@LeagueId int,
	@PlayRound int,
	@VgcNo1 int,
	@VgcNo2 int
as
 begin
	declare @season int = datepart(year, sysdatetime())
	select 1 from ms.League where LeagueId = @LeagueId and Single = 1
	if @vgcno1 > @vgcno2 begin
		THROW 50000, N'Medlemsnr 1 skal være mindre det 2.', 1
	end

	declare @teamId1 int	
	declare @teamId2 int

	SELECT @teamId1 =[LeagueTeamId] 
	FROM [ms].[LeagueTeam] 
	where [Season] = DATEPART(YEAR, sysdatetime()) and [VgcNo]=@vgcno1 and LeagueId = @LeagueId
	if @teamId1 is null begin
		THROW 50000, N'Team 1 not found.', 1
	end

	SELECT @teamId2 =[LeagueTeamId] 
	FROM [ms].[LeagueTeam] 
	where [Season] = DATEPART(YEAR, sysdatetime()) and [VgcNo]=@vgcno2 and LeagueId = @LeagueId
	if @vgcno1 > @vgcno2 begin
		THROW 50000, N'Team 2 not found.', 1
	end

	INSERT INTO [ms].[LeagueMatch]([LeagueId],[PlayRound],[LeagueTeamId1],[LeagueTeamId2]) 
	VALUES (@LeagueId,@PlayRound,@teamId1,@teamId2)
end