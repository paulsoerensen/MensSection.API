CREATE TABLE [ms].[Tour] (
    [TourId]               INT           IDENTITY (1, 1) NOT NULL,
    [TourDate]             DATE          NOT NULL,
    [Description]          VARCHAR (255) NULL,
    [LastRegistrationDate] DATE          NULL,
    [OpenForSignUp]        BIT           CONSTRAINT [DF_Tour_OpenForSignUp] DEFAULT ((0)) NULL,
    [MaxNoOfMembers]       INT           CONSTRAINT [DF_Tour_MaxNoOfMembers] DEFAULT ((-1)) NULL,
    [UrlDescription]       INT           CONSTRAINT [DF_Tour_UrlDescription] DEFAULT ((0)) NOT NULL,
    [NoOfMembers]          INT           CONSTRAINT [DF_Tour_NoOfMembers] DEFAULT ((0)) NOT NULL,
    [MatchId]              INT           NULL,
    [SponsorLogoId]        INT           CONSTRAINT [DF_Tour_SponsorLogoId] DEFAULT ((2286)) NOT NULL,
    [UrlRegistration]      VARCHAR (255) NULL,
    CONSTRAINT [PK_Tour] PRIMARY KEY CLUSTERED ([TourId] ASC)
);

