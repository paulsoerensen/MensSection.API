CREATE PROCEDURE [ms].[MatchResultSelectBirdieString]
	@MatchId int 
as
begin
   declare @list nvarchar(1024)
   declare @delim nvarchar(2)
   select @delim = ', '
   
   select 
      @list = isnull(@list + @delim, '') + 
		case r.Birdies
		when 1 then m.Firstname + ' ' + m.Lastname
		when 2 then m.Firstname + ' ' + m.Lastname + ' (2)'
		when 3 then m.Firstname + ' ' + m.Lastname + ' (3)'
		when 4 then m.Firstname + ' ' + m.Lastname + ' (4)'
		else m.Firstname + ' ' + m.Lastname + ' (4+)'
		end   
	FROM   ms.MatcResult r INNER JOIN
		   ms.MemberShip  as s ON r.MemberShipId = s.MemberShipId INNER JOIN
		   ms.Player m ON s.VgcNo = m.VgcNo
	WHERE  (r.Birdies > 0) AND (r.MatchId = @MatchId)
	ORDER BY m.Lastname
	
	select @list BirdieString
end