CREATE TABLE [ms].[Property] (
    [PropertyId]  INT           NOT NULL,
    [DataValue]   VARCHAR (255) NULL,
    [SystemType]  VARCHAR (50)  NULL,
    [ValidFrom]   DATE          NOT NULL,
    [ValidTo]     DATE          NULL,
    [Description] VARCHAR (50)  NULL,
    CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED ([PropertyId] ASC, [ValidFrom] ASC)
);

