CREATE TABLE [dbo].[Reader] (
    [ReaderId]        INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]       NVARCHAR (255) NULL,
    [LastName]        NVARCHAR (255) NULL,
    [PersonId]        INT            NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Reader_sysCreatedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Reader_sysChangedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_Reader] PRIMARY KEY CLUSTERED ([ReaderId] ASC),
    CONSTRAINT [FK_Person_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
);

