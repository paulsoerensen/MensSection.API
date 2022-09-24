CREATE TABLE [ms].[LeagueMatch] (
    [LeagueMatchId] INT           IDENTITY (1, 1) NOT NULL,
    [MatchResult]   INT           CONSTRAINT [DF_LeagueMatch_MatchResult] DEFAULT ((0)) NOT NULL,
    [ResultText]    NVARCHAR (50) NULL,
    [LeagueId]      INT           NOT NULL,
    [PlayRound]     INT           CONSTRAINT [DF_LeagueMatch_PlayRound] DEFAULT ((-1)) NOT NULL,
    [LeagueTeamId1] INT           NOT NULL,
    [LeagueTeamId2] INT           NOT NULL,
    [LastUpdate]    DATETIME2 (0) CONSTRAINT [DF_LeagueMatch_LastUpdate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_LeagueMatch] PRIMARY KEY CLUSTERED ([LeagueMatchId] ASC),
    CONSTRAINT [FK_LeagueMatch_League] FOREIGN KEY ([LeagueId]) REFERENCES [ms].[League] ([LeagueId]),
    CONSTRAINT [FK_LeagueMatch_LeagueTeam1] FOREIGN KEY ([LeagueTeamId1]) REFERENCES [ms].[LeagueTeam] ([LeagueTeamId]),
    CONSTRAINT [FK_LeagueMatch_LeagueTeam2] FOREIGN KEY ([LeagueTeamId2]) REFERENCES [ms].[LeagueTeam] ([LeagueTeamId]) ON DELETE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UC_LeagueMatch_LeagueId_PlayRound_LeagueTeamId1_LeagueTeamId2]
    ON [ms].[LeagueMatch]([LeagueId] ASC, [PlayRound] ASC, [LeagueTeamId1] ASC, [LeagueTeamId2] ASC);

