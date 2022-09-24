


CREATE VIEW [ms].[vMembers2]
AS
SELECT     TOP (100) PERCENT m.VgcNo, m.FirstName, m.LastName, m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.Phone, m.CellPhone, 
                      ms.MemberShipId, m.HcpIndex, ms.Fee, ms.Insurance, ms.Season, m.UmbracoMemberId, ms.Eclectic, m.HcpUpdated, 
                      m.LastUpdate
FROM         ms.Player AS m INNER JOIN
                      ms.MemberShip AS ms ON m.VgcNo = ms.VgcNo 
ORDER BY m.LastName