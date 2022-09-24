
create VIEW [ms].[vPlayer]
AS
SELECT p.VgcNo,
       p.Firstname,
       p.Lastname,
       p.ZipCode,
       p.City,
       p.[Address],
       p.Email,
       p.Sponsor,
       p.Phone,
       p.CellPhone,
       p.HcpIndex,
       m.Fee,
       m.Insurance,
       m.Season,
       m.Eclectic,
       p.HcpUpdated,
       p.LastUpdate,
       1 as IsMale,
       p.PlayerId,
       m.MemberShipId
	   , ms.PlayerNameGroup(p.Lastname) AS NameGroup
FROM   ms.Player AS p
       LEFT JOIN
       ms.MemberShip AS m
       ON p.VgcNo = m.VgcNo;