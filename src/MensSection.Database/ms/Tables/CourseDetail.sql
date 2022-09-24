CREATE TABLE [ms].[CourseDetail] (
    [CourseDetailId] INT            IDENTITY (1, 1) NOT NULL,
    [CourseId]       INT            NOT NULL,
    [CourseTeeId]    INT            NOT NULL,
    [IsMale]         INT            CONSTRAINT [DF__CourseDet__IsMal__7909C0DC] DEFAULT ((1)) NOT NULL,
    [Par]            INT            NOT NULL,
    [CourseRating]   DECIMAL (3, 1) NOT NULL,
    [Slope]          INT            NOT NULL,
    CONSTRAINT [PK_CourseDetail] PRIMARY KEY CLUSTERED ([CourseDetailId] ASC),
    CONSTRAINT [FK_CourseInfo_Course] FOREIGN KEY ([CourseId]) REFERENCES [ms].[Course] ([CourseId]),
    CONSTRAINT [FK_CourseInfo_CourseTee] FOREIGN KEY ([CourseTeeId]) REFERENCES [ms].[CourseTee] ([CourseTeeId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UC_CourseDetail_CourseId_CourseTeeId_GenderId]
    ON [ms].[CourseDetail]([CourseId] ASC, [CourseTeeId] ASC, [IsMale] ASC);

