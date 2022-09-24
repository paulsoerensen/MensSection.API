CREATE procedure [ms].[MemberShipSelectSeason]
@Season int,
@Part int
as
begin
	if @Part < 0 begin
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.City, 
			m.Phone, m.ZipCode,
			m.Firstname, m.Lastname, m.Season, ms.PlayerNameGroup(m.LastName) as NameGroup
		FROM ms.vMembers m 
		where m.Season=@Season 
		order by m.LastName, m.FirstName
	end
	else if @Part=0 begin
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.City, 
			m.Phone, m.ZipCode,
			m.Firstname, m.Lastname, m.Season, 0 as NameGroup
		FROM ms.vMember m 
		where m.Season=@Season and m.LastName <'c'
		order by m.LastName, m.FirstName
	end
	else if @Part=1 begin
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.City, 
			m.Phone, m.ZipCode,
			m.Firstname, m.Lastname, m.Season, 1 as NameGroup
		FROM ms.vMember m 
		where m.Season=@Season and LastName between 'c' and 'h'
		order by m.LastName, m.FirstName
	end
	else if @Part=2 begin
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.City, 
			m.Phone, m.ZipCode,
			m.Firstname, m.Lastname, m.Season, 2 as NameGroup
		FROM ms.vMember m 
		where m.Season=@Season and LastName between 'h' and 'j'
		order by m.LastName, m.FirstName
	end
	else if @Part=3 begin
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.City, 
			m.Phone, m.ZipCode,
			m.Firstname, m.Lastname, m.Season, 3 as NameGroup
		FROM ms.vMember m 
		where m.Season=@Season and LastName like 'j%' 
		order by m.LastName, m.FirstName
	end
	else if @Part=4 begin
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.City, 
			m.Phone, m.ZipCode,
			m.Firstname, m.Lastname, m.Season, 4 as NameGroup
		FROM ms.vMember m 
		where m.Season=@Season and LastName like 'k%' 
		order by m.LastName, m.FirstName
	end
	else if @Part=5 begin
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.City, 
			m.Phone, m.ZipCode,
			m.Firstname, m.Lastname, m.Season, 5 as NameGroup
		FROM ms.vMember m 
		where m.Season=@Season and LastName between 'l' and 'p'
		order by m.LastName, m.FirstName
	end
	else if @Part=6 begin
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.City, 
			m.Phone, m.ZipCode,
			m.Firstname, m.Lastname, m.Season, 6 as NameGroup
		FROM ms.vMember m 
		where m.Season=@Season and LastName between 'p' and 's'
		order by m.LastName, m.FirstName
	end 
	else if @Part=7 begin
		SELECT m.VgcNo, m.FirstName, m.LastName, 
			m.ZipCode, m.City, m.Address, m.Email, m.Sponsor, m.MemberShipId, m.HcpIndex, 
			m.Fee, m.insurance, m.[Address], m.CellPhone, m.City, 
			m.Phone, m.ZipCode,
			m.Firstname, m.Lastname, m.Season, 7 as NameGroup
		FROM ms.vMember m 
		where m.Season=@Season and LastName > 's%'
		order by m.LastName, m.FirstName
	end 
end