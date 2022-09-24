create PROCEDURE [ms].[TourSelectByID]
	@tourId int
AS

SELECT
	[TourId],
	[TourDate],
	[Description],
	LastRegistrationDate,
	[OpenForSignUp],
	[MaxNoOfMembers],
	[NoOfMembers],
	[UrlDescription]
FROM
	[ms].[Tour]
WHERE
	[TourId] = @tourId