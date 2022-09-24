

-- =============================================
-- Author:		Paul S	
-- Create date: 2015-02-01
-- Description:	Gets the HCP grp
-- =============================================
CREATE FUNCTION [ms].[HcpGroup]
(
	@border int,
	@hcpIndex numeric(3,1)
)
RETURNS int
	with schemabinding  
AS
BEGIN
	return 
	case 
	when @hcpIndex < @border then 1  
	else 2
	end
END