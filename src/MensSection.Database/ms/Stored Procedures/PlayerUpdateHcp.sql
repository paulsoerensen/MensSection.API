CREATE procedure [ms].[PlayerUpdateHcp]
	@VgcNo int,
	@HcpIndex decimal(3,1)
as begin
	update ms.[Player]
	set HcpIndex = @HcpIndex, HcpUpdated = sysdatetime()
	where Vgcno = @VgcNo and HcpIndex != @HcpIndex
	return @@rowcount
END