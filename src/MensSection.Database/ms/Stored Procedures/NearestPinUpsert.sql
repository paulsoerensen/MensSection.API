
------------------------------------------------------------------------------------------------------------------------
-- Date Created: 04. nov 2017
-- Created By:   Paul S
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [ms].[NearestPinUpsert]
	@MembershipId int,
	@MatchId int,
	@PinName varchar(100),
	@DistanceInCm int,
	@NearestPinId int OUTPUT
AS
begin
	IF @NearestPinId is null BEGIN
		select @NearestPinId = 0
	END;	
	MERGE ms.NearestPin as T
	USING (
	select @MemberShipId as MemberShipId, 
			@MatchId as MatchId, 
			@PinName as PinName,
			@DistanceInCm as cm,
			@NearestPinId as NearestPinId
		) as S
	ON S.NearestPinId = T.NearestPinId
	WHEN NOT MATCHED then 
		INSERT (MemberShipId, MatchId, PinName, DistanceInCm)
		VALUES (S.MemberShipId, S.MatchId, S.PinName, S.cm)
	WHEN MATCHED then 
		UPDATE set DistanceInCm=S.cm, 
			T.PinName = S.PinName,
			T.MatchId = S.MatchId,
			T.MemberShipId = S.MemberShipId;
	
	IF @NearestPinId < 1 BEGIN
		SELECT @NearestPinId = CAST(SCOPE_IDENTITY() as [int]);
	END;
end