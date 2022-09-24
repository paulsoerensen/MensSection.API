CREATE TABLE [ms].[Club] (
    [ClubId]   INT          IDENTITY (1, 1) NOT NULL,
    [ClubName] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Club] PRIMARY KEY CLUSTERED ([ClubId] ASC)
);

