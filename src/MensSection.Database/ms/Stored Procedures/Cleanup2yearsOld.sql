-- =============================================
-- Author:		Paul S
-- Create date: 8th Jan 2008
-- Description:	Cleanup data registrered more than 2 years ago
-- exec [ms].[Cleanup2yearsOld]
-- =============================================
CREATE PROCEDURE [ms].[Cleanup2yearsOld]
	AS
BEGIN

	select VgcNo, LastName, FirstName from ms.Player where VgcNo  in 
	(
		SELECT     VgcNo
		FROM         ms.vMembers
		GROUP BY VgcNo
		HAVING (MAX(Season) < DATEPART(yy, DATEADD(yy, - 2, GETDATE())))
	)
	SET NOCOUNT ON;
	delete ms.Match 
	where datediff(year, Matchdate, getdate()) > 2

	delete ms.membership
	where datepart(year, getdate()) - season > 2 

	delete ms.Tour
	where datediff(year, TourDate, getdate()) > 2

	delete ms.Player where vgcno not in 
	(select vgcno from ms.membership)
END