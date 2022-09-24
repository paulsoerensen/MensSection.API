
CREATE VIEW [ms].[vTour]
AS
SELECT   t.TourId, t.TourDate, t.[Description], t.OpenForSignUp, t.MaxNoOfMembers, t.UrlDescription, t.NoOfMembers
FROM    ms.Tour AS t CROSS JOIN
                         ms.Property AS p
WHERE        (t.tourDate BETWEEN DATEFROMPARTS(CAST(p.DataValue AS int), 1, 1) AND DATEFROMPARTS(CAST(p.DataValue AS int) + 1, 1, 1)) AND (p.PropertyId = 0)