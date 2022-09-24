
CREATE PROCEDURE [ms].[TourChangeRegistration]
	@TourId int,
	@VgcNo int,
	@LastUpdateBy varchar(50)
AS
begin
	merge ms.TourPlayer as T
	using (select @TourId as tourId, @VgcNo as vgcNo, @LastUpdateBy as lastUpdateBy) as S
	on T.TourId = S.tourId and T.VgcNo = S.vgcNo
	when matched then 
		update set T.[SignedUp] = case when T.[SignedUp] = 1 then 0 else 1 end,
		 T.LastUpdateBy = S.lastUpdateBy
	when not matched then 
		INSERT ([TourId],[VgcNo],[LastUpdateBy])
		VALUES (S.tourId, S.vgcNo, S.lastUpdateBy);

	update ms.Tour set NoOfMembers = 
		(select count(*) 
			from ms.TourPlayer 
			where TourId=@TourId and SignedUp=1)
	where TourId=@TourId
end