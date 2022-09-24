CREATE TABLE [ms].[Competition] (
    [CompetitionId]   INT          IDENTITY (1, 1) NOT NULL,
    [ListOrder]       INT          NOT NULL,
    [CompetitionText] VARCHAR (50) NULL,
    [ImageName]       VARCHAR (20) NULL,
    [Active]          BIT          NULL,
    CONSTRAINT [PK_Competition] PRIMARY KEY CLUSTERED ([CompetitionId] ASC)
);

