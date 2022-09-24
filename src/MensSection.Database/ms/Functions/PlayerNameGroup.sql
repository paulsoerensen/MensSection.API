-- =============================================
-- Author:		Paul S	
-- Create date: 2015-02-01
-- Description:	Groups players according to their last name
-- =============================================
CREATE FUNCTION [ms].[PlayerNameGroup]
(
	@Lastname varchar(50)
)
RETURNS int
	with schemabinding  
AS
BEGIN

	if @Lastname <'c' return 0
	if @Lastname between 'c' and 'h' return 1
	if @Lastname between 'h' and 'j' return 2
	if @Lastname  like 'j%'  return 3
	if @Lastname  like 'k%'  return 4
	if @Lastname between 'l' and 'p' return 5
	if @Lastname between 'p' and 's' return 6
	--if @Lastname > 's' 
	return 7
END