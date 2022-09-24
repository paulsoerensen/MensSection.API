CREATE TABLE [ms].[CourseTee] (
    [CourseTeeId] INT       IDENTITY (1, 1) NOT NULL,
    [Tee]         CHAR (10) NOT NULL,
    CONSTRAINT [PK_CourseTee] PRIMARY KEY CLUSTERED ([CourseTeeId] ASC)
);

