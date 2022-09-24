CREATE TABLE [ms].[TourPlayer] (
    [TourId]       INT           NOT NULL,
    [VgcNo]        INT           NOT NULL,
    [SignedUp]     BIT           CONSTRAINT [DF_TourPlayer_SignedUp] DEFAULT ((1)) NOT NULL,
    [LastUpdateBy] VARCHAR (50)  NOT NULL,
    [LastUpdate]   DATETIME2 (0) CONSTRAINT [DF_TourPlayer_SignUpUpdate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_TourPlayer] PRIMARY KEY CLUSTERED ([TourId] ASC, [VgcNo] ASC),
    CONSTRAINT [FK_TourPlayer_Player] FOREIGN KEY ([VgcNo]) REFERENCES [ms].[Player] ([VgcNo]),
    CONSTRAINT [FK_TourPlayer_Tour_TourId] FOREIGN KEY ([TourId]) REFERENCES [ms].[Tour] ([TourId]) ON DELETE CASCADE
);

