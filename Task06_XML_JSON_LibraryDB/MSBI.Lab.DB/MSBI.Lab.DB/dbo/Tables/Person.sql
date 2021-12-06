CREATE TABLE [dbo].[Person] (
    [PersonId]        INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]       NVARCHAR (255) NULL,
    [LastName]        NVARCHAR (255) NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Person_sysCreatedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Person_sysChangedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonId] ASC)
);

