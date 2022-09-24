CREATE proc  [ms].[LeagueTeamDoubleUpsert] 
	@LeagueId int,
	@VgcNo int, 
	@VgcNoPartner int
as
begin
	set nocount on
	declare @season int = datepart(year, sysdatetime())
	select 1 from ms.League where LeagueId = @LeagueId and Single = 0
	if @@ROWCOUNT = 0 begin
		THROW 50000, N'League not found', 1
	end

	if @VgcNoPartner is not null and @VgcNo > @VgcNoPartner begin
		declare @i int = @VgcNoPartner
		set @VgcNoPartner = @VgcNo
		set @VgcNo = @i
	end

	declare @fullname nvarchar(100)
	select @fullname = Firstname + ' ' + lastname from ms.Player where VgcNo = @VgcNo
	if @@ROWCOUNT = 0 begin
		THROW 50000, N'Player not found', 1
	end

	if @VgcNoPartner = 9999 begin
		select @fullname = @fullname + ', mangler partner'
	end else begin
		select @fullname = @fullname + ', ' + Firstname + ' ' + lastname from ms.Player where VgcNo = @VgcNoPartner
		if @@ROWCOUNT = 0 begin
			THROW 50000, N'Partner not found', 1
		end
	end

	merge ms.LeagueTeam as T 
	using (select @LeagueId as LeagueId, @fullname as Teamname, @VgcNo as VgcNo, @VgcNoPartner as VgcNoPartner, @season as season) as S
	on S.LeagueId = T.LeagueId and S.VgcNo = T.VgcNo and T.Season = @Season
	when matched then update 
		set TeamName = @fullname, VgcNoPartner = @VgcNoPartner
	when not matched then insert 
		([LeagueId],[TeamName],[VgcNo],[VgcNoPartner],[Season])
		VALUES (S.LeagueId,S.TeamName,S.VgcNo,S.VgcNoPartner,S.Season);
end