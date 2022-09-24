CREATE TABLE [ms].[Match] (
    [MatchId]        INT           IDENTITY (1, 1) NOT NULL,
    [MatchDate]      DATE          NOT NULL,
    [MatchformId]    INT           NOT NULL,
    [CourseDetailId] INT           NOT NULL,
    [Par]            INT           NOT NULL,
    [MatchText]      TEXT          CONSTRAINT [DF_Match_Description] DEFAULT ('Torsdags match') NULL,
    [Sponsor]        VARCHAR (50)  NULL,
    [SponsorLogoId]  VARCHAR (250) CONSTRAINT [DF_Match_SponsorLogoUrl] DEFAULT ('') NULL,
    [Remarks]        TEXT          CONSTRAINT [DF_Match_Remarks] DEFAULT ('') NULL,
    [Official]       BIT           CONSTRAINT [DF_Match_Official] DEFAULT ((0)) NOT NULL,
    [timestamp]      ROWVERSION    NULL,
    [Shootout]       BIT           CONSTRAINT [DF_Match_Shootout] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_MatchId] PRIMARY KEY CLUSTERED ([MatchId] ASC),
    CONSTRAINT [FK_Match_CourseInfo] FOREIGN KEY ([CourseDetailId]) REFERENCES [ms].[CourseDetail] ([CourseDetailId]),
    CONSTRAINT [FK_Match_Matchform] FOREIGN KEY ([MatchformId]) REFERENCES [ms].[Matchform] ([MatchformId])
);

