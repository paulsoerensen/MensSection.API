
CREATE proc  [ms].[LeagueTeamUpsert] 
	@LeagueId int,
	@VgcNo int
as
 begin
	declare @season int = datepart(year, sysdatetime())
	select 1 from ms.League where LeagueId = @LeagueId and Single = 1
	if @@ROWCOUNT = 0 begin
		THROW 50000, N'League not found', 1
	end

	declare @fullname nvarchar(100)
	select @fullname = Firstname + ' ' + lastname from ms.Player where VgcNo = @VgcNo
	if @@ROWCOUNT = 0 begin
		THROW 50000, N'Player not found', 1
	end

	merge ms.LeagueTeam as T 
	using (select @LeagueId as LeagueId, @fullname as Teamname, @VgcNo as VgcNo, @season as season) as S
	on S.VgcNo = T.VgcNo and S.Season = T.Season and T.VgcNoPartner is null
	when matched then update set TeamName = @fullname, LeagueId = @LeagueId
	when not matched then insert 
		([LeagueId],[TeamName],[VgcNo],[Season])
		VALUES (S.LeagueId,S.TeamName,S.VgcNo,S.Season);
end