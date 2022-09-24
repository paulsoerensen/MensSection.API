CREATE TABLE [ms].[MatchResult] (
    [MatchResultId]  INT            IDENTITY (1, 1) NOT NULL,
    [MemberShipId]   INT            NOT NULL,
    [MatchId]        INT            NOT NULL,
    [HcpIndex]       NUMERIC (3, 1) CONSTRAINT [DF_MatchResult_HcpIndex] DEFAULT ((54)) NOT NULL,
    [Hcp]            INT            CONSTRAINT [DF_MatchResult_Hcp] DEFAULT ((0)) NOT NULL,
    [Puts]           INT            NULL,
    [Brutto]         INT            NULL,
    [DamstahlPoints] INT            CONSTRAINT [DF_MatchResult_DamstahlPoints] DEFAULT ((0)) NOT NULL,
    [Points]         INT            CONSTRAINT [DF_MatchResult_Points] DEFAULT ((24)) NOT NULL,
    [Birdies]        INT            CONSTRAINT [DF_MatchResult_Birdies] DEFAULT ((0)) NOT NULL,
    [Rank]           INT            CONSTRAINT [DF_MatchResult_Rank] DEFAULT ((1000)) NOT NULL,
    [OverallWinner]  BIT            NULL,
    [Hallington]     INT            NULL,
    [LastUpdate]     DATETIME2 (0)  CONSTRAINT [DF_MatchResult_LastUpdate] DEFAULT (getdate()) NULL,
    [timestamp]      ROWVERSION     NOT NULL,
    [HcpGroup]       INT            CONSTRAINT [DF_MatchResult_HcpGroup] DEFAULT ((3)) NOT NULL,
    [Dining]         BIT            CONSTRAINT [DF_MatchResult_Dining] DEFAULT ((1)) NOT NULL,
    [ShootOut]       INT            NULL,
    CONSTRAINT [PK_MatchResult] PRIMARY KEY CLUSTERED ([MatchResultId] ASC),
    CONSTRAINT [CK_MatchResult_HcpGroup] CHECK ([HcpGroup]>=(1) AND [HcpGroup]<=(3)),
    CONSTRAINT [FK_MatchResult_Match] FOREIGN KEY ([MatchId]) REFERENCES [ms].[Match] ([MatchId]) ON DELETE CASCADE,
    CONSTRAINT [FK_MatchResult_MemberShip] FOREIGN KEY ([MemberShipId]) REFERENCES [ms].[MemberShip] ([MemberShipId]) ON DELETE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_MatchResult_MatchId_MemberShipId]
    ON [ms].[MatchResult]([MatchId] ASC, [MemberShipId] ASC);

