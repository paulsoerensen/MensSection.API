

CREATE PROCEDURE [ms].[MatchResultSelectWinners] 
	@matchId int,
	@MaxA int= 13,
	@hcpGroup int = -1
as
begin
	declare @matchformid int
	SELECT @matchformid=matchformid FROM ms.vMatch 
	where  MatchId=@matchId 

	if @HcpGroup = -1 begin
		set @hcpGroup = null
	end         
	   
	if @matchformid=1 begin
		SELECT r.MatchId, r.Puts, r.Brutto, r.Netto, r.Points, r.OverallWinner,r.Par,
			r.Birdies, r.HcpIndex, r.MatchResultId, r.MatchDate, r.Official, r.[Rank], r.ClubName, r.CourseName, 
			Rank() over  (Partition by HcpGroup, OverallWinner order by Netto asc) as [No], 
			r.Hallington, r.DamstahlPoints, r.Hcp, r.Lastname, r.Firstname, r.VgcNo, r.MemberShipId, 
			r.HcpGroup, r.[timestamp], r.Dining, Shootout, @MaxA as maxA
		FROM ms.vMatchResult AS r 
		where r.MatchId=@matchId and (HcpGroup = @hcpGroup or @hcpGroup is null)
		order by [Rank], Netto
	end
	else if @matchformid=3 begin -- Hallington
		SELECT r.MatchId, r.Puts, r.Brutto, r.Netto, r.Points, r.OverallWinner,r.Par,
			r.Birdies, r.HcpIndex, r.MatchResultId, r.MatchDate, r.Official, r.[Rank], r.ClubName, r.CourseName, 
			Rank() over  (Partition by HcpGroup, OverallWinner order by Hallington desc) as [No], 
			r.Hallington, r.DamstahlPoints, r.Hcp, r.Lastname, r.Firstname, r.VgcNo, r.MemberShipId, 
			r.HcpGroup, r.[timestamp], r.Dining, Shootout, @MaxA as maxA
		FROM ms.vMatchResult AS r 
		where r.MatchId=@matchId and (HcpGroup = @hcpGroup or @hcpGroup is null)
		order by [Rank], Hallington desc
	end
	else begin
		SELECT r.MatchId, r.Puts, r.Brutto, r.Netto, r.Points, r.OverallWinner, 
			r.Birdies, r.HcpIndex, r.MatchResultId, r.MatchDate, r.Official, r.[Rank], r.ClubName, r.CourseName, 
			rank() over  (Partition by HcpGroup, OverallWinner order by Points desc) as [No], 
			r.Hallington, r.DamstahlPoints, r.Hcp, r.Lastname, r.Firstname, r.VgcNo, r.MemberShipId, 
			r.HcpGroup, r.[timestamp], r.Dining, Shootout, @MaxA as maxA
		FROM ms.vMatchResult AS r 
		where r.MatchId=@matchId and (HcpGroup = @hcpGroup or @hcpGroup is null)
		order by [Rank], Points
	end
end