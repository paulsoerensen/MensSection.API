CREATE TABLE [ms].[MemberShip] (
    [MemberShipId] INT           IDENTITY (1, 1) NOT NULL,
    [VgcNo]        INT           NOT NULL,
    [Fee]          BIT           CONSTRAINT [DF_MemberShip_Fee] DEFAULT ((0)) NOT NULL,
    [Insurance]    BIT           CONSTRAINT [DF_MemberShip_Insurance] DEFAULT ((0)) NOT NULL,
    [Season]       INT           CONSTRAINT [DF_MemberShip_Season] DEFAULT (datepart(year,getdate())) NOT NULL,
    [Eclectic]     BIT           CONSTRAINT [DF_MemberShip_Eclectic] DEFAULT ((0)) NOT NULL,
    [LastUpdate]   DATETIME2 (0) CONSTRAINT [DF_MemberShip_LastUpdate] DEFAULT (getdate()) NULL,
    [timestamp]    ROWVERSION    NULL,
    CONSTRAINT [PK_MemberShip] PRIMARY KEY CLUSTERED ([MemberShipId] ASC),
    CONSTRAINT [FK_MemberShip_Player_VgcNo] FOREIGN KEY ([VgcNo]) REFERENCES [ms].[Player] ([VgcNo]) ON DELETE CASCADE
);

