
CREATE proc [ms].[TeeUpsert]
	@courseTeeId int output,
	@teeName varchar(50)
AS
BEGIN
	set nocount on
	;WITH S as (
		select @courseTeeId as courseTeeId, @teeName as Tee
    )
    MERGE [ms].[CourceTee] AS T
    USING S
            ON S.courseTeeId = T.courseTeeId
    WHEN MATCHED THEN UPDATE SET 
        Tee = S.Tee
    WHEN NOT MATCHED THEN INSERT
        (
            courseTeeId, 
            Tee
        )
        VALUES (
            S.courseTeeId, 
            S.Tee
        );
END