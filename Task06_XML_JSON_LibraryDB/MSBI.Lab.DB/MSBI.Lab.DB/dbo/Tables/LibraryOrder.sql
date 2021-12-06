CREATE TABLE [dbo].[LibraryOrder] (
    [LibraryOrderId]  INT      IDENTITY (1, 1) NOT NULL,
    [LibraryStaffId]  INT      NULL,
    [ReaderId]        INT      NULL,
    [BookId]          INT      NULL,
    [AuthorId]        INT      NULL,
    [sysCreatedAtUTC] DATETIME CONSTRAINT [DF_LibraryOrder_sysCreatedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    [sysChangedAtUTC] DATETIME CONSTRAINT [DF_LibraryOrder_sysChangedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_LibraryOrder] PRIMARY KEY CLUSTERED ([LibraryOrderId] ASC),
    CONSTRAINT [FK_LibraryOrder_BookId] FOREIGN KEY ([BookId]) REFERENCES [dbo].[Book] ([BookId]),
    CONSTRAINT [FK_LibraryOrder_ReaderId] FOREIGN KEY ([ReaderId]) REFERENCES [dbo].[Reader] ([ReaderId]),
    CONSTRAINT [FK_LibraryOrderr_AuthorId] FOREIGN KEY ([AuthorId]) REFERENCES [dbo].[Author] ([AuthorId])
);

