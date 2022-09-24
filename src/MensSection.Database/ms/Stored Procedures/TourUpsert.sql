create procedure [ms].[TourUpsert]
	@TourId [int] output,
	@TourDate [date],
	@Description [varchar](255),
	@LastRegistrationDate [date],
	@OpenForSignUp [bit],
	@MaxNoOfMembers [int],
	@UrlDescription [int],
	@NoOfMembers [int],
	@MatchId [int],
	@SponsorLogoId [int]
as begin
	set nocount on

	if @TourId < 1 begin
		SELECT @TourId = TourId	
		from Ms.Tour
		where TourDate = @TourDate
	end

	MERGE [ms].[Tour] AS T
	USING (
		SELECT @TourId as [TourId]
		  ,@TourDate as [TourDate]
		  ,@Description as [Description]
		  ,@LastRegistrationDate as [LastRegistrationDate]
		  ,@OpenForSignUp as [OpenForSignUp]
		  ,@MaxNoOfMembers as [MaxNoOfMembers]
		  ,@UrlDescription as [UrlDescription]
		  ,@NoOfMembers as [NoOfMembers]
		  ,@MatchId as [MatchId]
		  ,@SponsorLogoId as [SponsorLogoId]
	) as  S
		 ON S.[TourId] = T.[TourId]
	WHEN MATCHED THEN UPDATE SET 
		T.[TourDate] = S.[TourDate],
		T.[Description] = S.[Description],
		T.[LastRegistrationDate] = S.[LastRegistrationDate],
		T.[OpenForSignUp] = S.[OpenForSignUp],
		T.[MaxNoOfMembers] = S.[MaxNoOfMembers],
		T.[UrlDescription] = S.[UrlDescription],
		T.[NoOfMembers] = S.[NoOfMembers],
		T.[MatchId] = S.[MatchId],
		T.[SponsorLogoId] = S.[SponsorLogoId]
	WHEN NOT MATCHED THEN INSERT
		(
			[TourDate], 
			[Description], 
			[LastRegistrationDate], 
			[OpenForSignUp], 
			[MaxNoOfMembers], 
			[UrlDescription], 
			[NoOfMembers], 
			[MatchId], 
			[SponsorLogoId] 
		)
		VALUES (
			S.[TourDate], 
			S.[Description], 
			S.[LastRegistrationDate], 
			S.[OpenForSignUp], 
			S.[MaxNoOfMembers], 
			S.[UrlDescription], 
			S.[NoOfMembers], 
			S.[MatchId], 
			S.[SponsorLogoId] 
		);

	IF @TourId < 1	BEGIN
		SELECT @TourId = CAST(SCOPE_IDENTITY() as [int]);
	END;	
	select @TourId
	set nocount off
END