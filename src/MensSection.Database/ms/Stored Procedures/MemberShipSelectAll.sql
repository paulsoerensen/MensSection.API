-- exec [ms].[MemberShipSelectAll] @Season=2020
CREATE procedure [ms].[MemberShipSelectAll]
	@Season int
as
begin
	with cte as (
		SELECT distinct VgcNo
		FROM ms.vMembers2 
		WHERE Season > @Season - 2
	)
	, xx as (
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.HcpUpdated, 
			m.Phone, m.Season, 
			row_number() over (partition by m.vgcNo order by m.Season desc) as rn,
			ms.PlayerNameGroup(m.LastName) as NameGroup
		FROM ms.vMembers2 as m 
		inner join cte 
		on m.VgcNo = cte.VgcNo
	)
	SELECT VgcNo, FirstName, LastName, ZipCode, City, [Address], Email, Sponsor, 
		MemberShipId, HcpIndex, Fee, Insurance, CellPhone, Phone, NameGroup, HcpUpdated
	from xx
	where rn = 1
	order by LastName, FirstName
end