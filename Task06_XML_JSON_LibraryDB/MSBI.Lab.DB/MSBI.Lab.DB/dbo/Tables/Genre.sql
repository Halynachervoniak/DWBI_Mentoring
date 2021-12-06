CREATE TABLE [dbo].[Genre] (
    [GenreId]         INT            IDENTITY (1, 1) NOT NULL,
    [GenreName]       NVARCHAR (255) NULL,
    [Description]     NVARCHAR (255) NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Genre_sysCreatedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Genre_sysChangedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED ([GenreId] ASC)
);

