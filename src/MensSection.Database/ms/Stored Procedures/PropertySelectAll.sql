CREATE PROCEDURE [ms].[PropertySelectAll]
	@ValidDate Date = null
AS
BEGIN
	SET NOCOUNT ON;
	    IF @ValidDate IS NULL BEGIN
        SET @ValidDate = sysdatetime();
    END;


	SELECT [PropertyId]
		  ,[DataValue]
		  ,[SystemType]
		  ,[ValidFrom]
		  ,[ValidTo]
		  ,[Description]
	  FROM [ms].[Property]
	where
		(ValidFrom < @ValidDate and (@ValidDate < ValidTo  or ValidTo is null))
	order by [PropertyId], ValidFrom
END