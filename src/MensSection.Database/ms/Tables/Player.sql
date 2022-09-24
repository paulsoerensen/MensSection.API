CREATE TABLE [ms].[Player] (
    [PlayerId]        INT            IDENTITY (1, 1) NOT NULL,
    [VgcNo]           INT            NOT NULL,
    [IsMale]          BIT            CONSTRAINT [DF_Player_IsMale] DEFAULT ((1)) NOT NULL,
    [Firstname]       VARCHAR (50)   NOT NULL,
    [Lastname]        VARCHAR (50)   NULL,
    [ZipCode]         VARCHAR (10)   NULL,
    [City]            VARCHAR (30)   NULL,
    [Address]         VARCHAR (50)   NULL,
    [Email]           VARCHAR (50)   NULL,
    [Sponsor]         BIT            CONSTRAINT [DF_Player_Sponsor] DEFAULT ((0)) NOT NULL,
    [HcpIndex]        DECIMAL (3, 1) CONSTRAINT [DF_Player_HcpIndex] DEFAULT ((36)) NOT NULL,
    [HcpUpdated]      DATETIME2 (0)  CONSTRAINT [DF_Player_HcpUpdated] DEFAULT (getdate()) NOT NULL,
    [LastUpdate]      DATETIME2 (0)  CONSTRAINT [DF_Player_LastUpdate] DEFAULT (getdate()) NOT NULL,
    [Phone]           VARCHAR (50)   NULL,
    [CellPhone]       VARCHAR (50)   NULL,
    [UmbracoMemberId] INT            CONSTRAINT [DF_Player_UmbracoMemberId] DEFAULT ((-1)) NOT NULL,
    [timestamp]       ROWVERSION     NULL,
    CONSTRAINT [PK_Player] PRIMARY KEY CLUSTERED ([VgcNo] ASC)
);

