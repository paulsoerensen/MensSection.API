CREATE TABLE [ms].[Matchform] (
    [MatchformId] INT          IDENTITY (1, 1) NOT NULL,
    [MatchForm]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Matchform] PRIMARY KEY CLUSTERED ([MatchformId] ASC)
);

