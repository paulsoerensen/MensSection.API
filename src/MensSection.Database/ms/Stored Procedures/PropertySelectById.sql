CREATE PROCEDURE [ms].[PropertySelectById]
	@PropertyId int,
	@ValidFrom Date = null
AS
BEGIN
	SET NOCOUNT ON;
	    IF @ValidFrom IS NULL BEGIN
        SET @ValidFrom = sysdatetime();
    END;

	SELECT
		[PropertyId], 
		[DataValue], 
		[SystemType] 
	FROM
		ms.Property
	WHERE
		[PropertyId] = @PropertyId
		and (ValidFrom < @ValidFrom and (@ValidFrom < ValidTo  or ValidTo is null))
	order by PropertyId, ValidFrom
END