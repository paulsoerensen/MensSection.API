

CREATE procedure [ms].[MemberShipUpsert]
@MemberShipId int OUTPUT,
@VgcNo int,
@Season int,
@Fee bit = 0,
@Insurance bit = 0,
@Eclectic bit = 0
as
begin
	MERGE ms.[MemberShip] as T
	USING (
	select @MemberShipId as MemberShipId, @VgcNo as [VgcNo], @Fee as [Fee], @Insurance as [Insurance]
		, @Eclectic as [Eclectic], @Season as [Season]
		) as S
	ON S.[VgcNo] = T.[VgcNo] and S.[Season] = T.[Season]
	WHEN NOT MATCHED then 
		INSERT ( [VgcNo], [Fee], [Insurance], [Eclectic], [Season])
		VALUES  (@VgcNo, @Fee, @Insurance, @Eclectic, @Season)
	WHEN MATCHED then 
		UPDATE set T.Fee = S.[Fee], T.Insurance = S.[Insurance]
			, T.Eclectic = S.[Eclectic];
	
	SELECT @MemberShipId = MemberShipId 
	from ms.[MemberShip]
	where [VgcNo] = @VgcNo and [Season] = @Season
end