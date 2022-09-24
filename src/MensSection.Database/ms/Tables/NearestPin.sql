CREATE TABLE [ms].[NearestPin] (
    [NearestPinId] INT           IDENTITY (1, 1) NOT NULL,
    [MemberShipId] INT           NOT NULL,
    [MatchId]      INT           NOT NULL,
    [PinName]      VARCHAR (100) NOT NULL,
    [DistanceInCm] INT           NOT NULL,
    CONSTRAINT [PK_NearestPin] PRIMARY KEY CLUSTERED ([NearestPinId] ASC),
    CONSTRAINT [FK_NearestPin_Match] FOREIGN KEY ([MatchId]) REFERENCES [ms].[Match] ([MatchId]) ON DELETE CASCADE,
    CONSTRAINT [FK_NearestPin_Membership] FOREIGN KEY ([MemberShipId]) REFERENCES [ms].[MemberShip] ([MemberShipId]) ON DELETE CASCADE
);

