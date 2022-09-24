CREATE proc [ms].[MatchUpsert]
	@MatchId int output,
	@MatchDate datetime,
	@MatchformId int,
	@CourseDetailId int,
	@Par int = null,
	@Description varchar(50),
	@Sponsor varchar(50),
	@SponsorLogoId int,
	@Remarks text,
	@Official bit = 1,
	@Shootout bit = 0,
	@timestamp timestamp
AS
BEGIN
	set nocount on

	if @Par is null begin
		SELECT @par = [Par]
		FROM [ms].[CourseDetail]
		where [CourseDetailId] = @CourseDetailId
	end
	if @MatchId < 1 begin
		SELECT @MatchId = MatchId	
		from Ms.Match
		where MatchDate = @MatchDate
	end

	Merge Ms.Match as T
	USING (SELECT
	@MatchId as MatchId,
	@MatchDate as MatchDate,
	@MatchformId as MatchformId,
	@CourseDetailId as CourseDetailId,
	@Par as Par,
	@Description as Description,
	@Sponsor as Sponsor,
	@SponsorLogoId as SponsorLogoId,
	@Remarks as Remarks,
	@Official as Official,
	@Shootout as Shootout,
	@timestamp as timestamp)  AS S
	ON T.MatchId = S.MatchId
	When matched then update 
		SET T.MatchDate = S.MatchDate,
		T.MatchformId = S.MatchformId,
		T.Par = S.Par,
		T.CourseDetailId = S.CourseDetailId,
		T.[MatchText] = S.[Description],
		T.Sponsor = S.Sponsor,
		T.SponsorLogoId = S.SponsorLogoId,
		T.Remarks = S.Remarks,
		T.Official =  S.Official,
		T.Shootout =  S.Shootout
	WHEN NOT MATCHED THEN INSERT 
				(MatchDate, MatchformId, CourseDetailId, [MatchText], Sponsor, SponsorLogoId, Remarks,Official,Shootout, Par)
		VALUES (S.MatchDate, S.MatchformId, S.CourseDetailId, S.[Description], S.Sponsor, S.SponsorLogoId, S.Remarks,S.Official,S.Shootout, S.Par);

	IF @MatchId < 1	BEGIN
		SELECT @MatchId = CAST(SCOPE_IDENTITY() as [int]);
	END;	
	set nocount off
END