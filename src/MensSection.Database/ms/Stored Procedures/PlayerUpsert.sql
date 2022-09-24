CREATE procedure [ms].[PlayerUpsert]
	@VgcNo int,
	@Firstname varchar(50),
	@Lastname varchar(50),
	@ZipCode varchar(10),
	@City varchar(30),
	@Address varchar(50),
	@Email varchar(50),
	@Sponsor bit,
	@Phone varchar(50),
	@HcpIndex decimal(3,1)
as begin
	MERGE [Player] as T 
	USING (SELECT @VgcNo as VgcNo,@Firstname as Firstname,@Lastname as Lastname
			,@ZipCode as ZipCode,@City as City,@Address as Address,@Email as Email,
			@Sponsor as Sponsor, @Phone as Phone, @HcpIndex as HcpIndex) as S
			ON T.VgcNo = S.VgcNo
	WHEN matched then UPDATE
		SET	T.VgcNo = S.VgcNo,
			T.Firstname	= S.Firstname,
			T.Lastname = S.Lastname,
			T.ZipCode = S.ZipCode,
			T.City = S.City,
			T.Address = S.Address,
			T.Email = S.Email,
			T.Sponsor = S.Sponsor,
			T.Phone = S.Phone,
			T.HcpIndex = S.HcpIndex
	WHEN not matched THEN INSERT
			(VgcNo,Firstname,Lastname,ZipCode,City,Address,Email,
			Sponsor,Phone, HcpIndex)
		VALUES (S.VgcNo,S.Firstname,S.Lastname,S.ZipCode,S.City,S.Address,S.Email,S.Sponsor
			,S.Phone, S.HcpIndex);
END