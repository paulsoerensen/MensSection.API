
CREATE PROCEDURE [ms].[TourPlayerSelect]
@tourId int,
@extra int = 0
AS begin

	declare @maxNo int
	SELECT @maxNo= MaxNoOfMembers
	FROM ms.Tour
	WHERE TourId = @tourId

	declare @free int
	SELECT @free= @maxNo-COUNT(*)
	FROM ms.TourPlayer
	WHERE TourId = @tourId and SignedUp = 1


	if @extra > 0 and @extra > @free begin
		set @extra = @free
	end

	SELECT
		row_number() over (order by m.vgcno) as rn, 
		TourId,
		p.VgcNo,
		SignedUp,
		LastUpdateBy,
		p.LastUpdate,
		Lastname, 
		Firstname,
		HcpIndex
	FROM ms.Player m INNER JOIN
		 ms.TourPlayer p ON m.VgcNo = p.VgcNo
	WHERE
		TourId = @tourId
	union
		SELECT top(@Extra) row_number() over (order by vgcno) as rn, @tourId, null as vgcNo, 0 as SignedUp, '' as LastUpdateBy
			, null as LastUpdate, '' as Lastname, null as Firstname, null as HcpIndex
		from ms.Player 
	Order by SignedUp desc, Lastname
end