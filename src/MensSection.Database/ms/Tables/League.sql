CREATE TABLE [ms].[League] (
    [LeagueId]   INT           NOT NULL,
    [LeagueName] NVARCHAR (10) NOT NULL,
    [Single]     BIT           CONSTRAINT [DF__League__Single__65B197AF] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_League] PRIMARY KEY CLUSTERED ([LeagueId] ASC)
);

