
CREATE proc [ms].[ClubUpsert]
	@clubId int output,
	@clubName varchar(50)
AS
BEGIN
	set nocount on
	;WITH S as (
		select @clubName as ClubName, @clubId as ClubId
    )
    MERGE [ms].[Club] AS T
    USING S
            ON S.ClubId = T.ClubId
    WHEN MATCHED THEN UPDATE SET 
        ClubName = S.ClubName
    WHEN NOT MATCHED THEN INSERT
        (
            ClubId, 
            ClubName
        )
        VALUES (
            S.ClubId, 
            S.ClubName
        );
END