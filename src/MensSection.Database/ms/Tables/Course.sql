CREATE TABLE [ms].[Course] (
    [CourseId]   INT          IDENTITY (1, 1) NOT NULL,
    [CourseName] VARCHAR (50) NOT NULL,
    [ClubId]     INT          NOT NULL,
    CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED ([CourseId] ASC),
    CONSTRAINT [FK_Course_Club] FOREIGN KEY ([ClubId]) REFERENCES [ms].[Club] ([ClubId])
);

