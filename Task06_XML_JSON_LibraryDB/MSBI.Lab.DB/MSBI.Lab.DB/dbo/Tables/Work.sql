CREATE TABLE [dbo].[Work] (
    [WorkId]          INT            IDENTITY (1, 1) NOT NULL,
    [WorkName]        NVARCHAR (255) NULL,
    [AuthorId]        INT            NULL,
    [GenreId]         INT            NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Work_sysCreatedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Work_sysChangedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_Work] PRIMARY KEY CLUSTERED ([WorkId] ASC),
    CONSTRAINT [FK_Work_AuthorId] FOREIGN KEY ([AuthorId]) REFERENCES [dbo].[Author] ([AuthorId]),
    CONSTRAINT [FK_Work_GenreId] FOREIGN KEY ([GenreId]) REFERENCES [dbo].[Genre] ([GenreId])
);

