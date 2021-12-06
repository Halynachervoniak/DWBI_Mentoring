CREATE TABLE [dbo].[Book] (
    [BookId]          INT            IDENTITY (1, 1) NOT NULL,
    [BookName]        NVARCHAR (255) NULL,
    [LastName]        NVARCHAR (255) NULL,
    [AuthorId]        INT            NULL,
    [WorkId]          INT            NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Book_sysCreatedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Book_sysChangedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED ([BookId] ASC),
    CONSTRAINT [FK_Book_AuthorId] FOREIGN KEY ([AuthorId]) REFERENCES [dbo].[Author] ([AuthorId]),
    CONSTRAINT [FK_Book_WorkId] FOREIGN KEY ([WorkId]) REFERENCES [dbo].[Work] ([WorkId])
);

