
-- =============================================
-- Author:		Paul S	
-- Create date: 2015-02-01
-- Description:	Gets the border between A and B
-- =============================================
CREATE FUNCTION [ms].[HcpGroupBorder]
(
	@calculationDate datetime2(0) = SYSDATETIME
)
RETURNS int
	with schemabinding  
AS
BEGIN
	declare @GroupA int
	SELECT @GroupA = convert(int, [DataValue]) FROM ms.Property 
	WHERE PropertyId = 11 
	and ValidFrom <= @calculationDate
	and (@calculationDate < ValidTo or ValidTo is null)
	if @@ROWCOUNT < 1 begin
		select @GroupA= 16
	end
	return @GroupA
END