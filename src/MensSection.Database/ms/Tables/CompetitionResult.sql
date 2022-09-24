CREATE TABLE [ms].[CompetitionResult] (
    [CompetitionResultId] INT IDENTITY (1, 1) NOT NULL,
    [MatchId]             INT NOT NULL,
    [MembershipId]        INT NOT NULL,
    [CompetitionId]       INT NOT NULL,
    CONSTRAINT [PK_CompetitionResult] PRIMARY KEY CLUSTERED ([CompetitionResultId] ASC),
    CONSTRAINT [FK_CompetitionResult_Competition] FOREIGN KEY ([CompetitionId]) REFERENCES [ms].[Competition] ([CompetitionId]) ON DELETE CASCADE,
    CONSTRAINT [FK_CompetitionResult_Match] FOREIGN KEY ([MatchId]) REFERENCES [ms].[Match] ([MatchId]) ON DELETE CASCADE
);

