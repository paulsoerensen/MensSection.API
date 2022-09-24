
CREATE VIEW [ms].[vMembers]
AS
SELECT     TOP (100) PERCENT m.VgcNo, m.FirstName, m.LastName, m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.Phone, m.CellPhone, 
                      ms.MemberShipId, m.HcpIndex, ms.Fee, ms.Insurance, ms.Season, m.UmbracoMemberId, ms.Eclectic, m.HcpUpdated, 
                      m.LastUpdate
FROM         ms.Player AS m INNER JOIN
                      ms.MemberShip AS ms ON m.VgcNo = ms.VgcNo 
		INNER JOIN [ms].[Property] as p
		ON cast(p.[DataValue] as int) = ms.Season
where PropertyId = 0
ORDER BY m.LastName