CREATE TABLE [ms].[LeagueTeam] (
    [LeagueTeamId] INT            IDENTITY (1, 1) NOT NULL,
    [LeagueId]     INT            NOT NULL,
    [Season]       INT            CONSTRAINT [DF__LeagueTea__Seaso__6D52B977] DEFAULT (datepart(year,sysdatetime())) NOT NULL,
    [TeamName]     NVARCHAR (250) NOT NULL,
    [VgcNo]        INT            NOT NULL,
    [VgcNoPartner] INT            NULL,
    CONSTRAINT [PK_LeagueTeam] PRIMARY KEY CLUSTERED ([LeagueTeamId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_LeagueTeam_Season_LeagueId_VgcNo]
    ON [ms].[LeagueTeam]([Season] ASC, [LeagueId] ASC, [VgcNo] ASC);

