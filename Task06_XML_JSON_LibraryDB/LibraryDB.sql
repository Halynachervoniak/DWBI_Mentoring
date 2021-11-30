CREATE TABLE [dbo].[Person]
(
    [PersonId]        INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]       NVARCHAR (255)                     NULL,
    [LastName]        NVARCHAR (255)                     NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Person_sysCreatedAtUTC] DEFAULT (getutcdate()) NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Person_sysChangedAtUTC] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonId] ASC)
);
--DROP TABLE [dbo].[Person]
GO

CREATE TABLE [dbo].[Genre] 
(
    [GenreId]         INT            IDENTITY (1, 1) NOT NULL,
    [GenreName]       NVARCHAR (255)                     NULL,
    [Description]     NVARCHAR (255)                     NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Genre_sysCreatedAtUTC] DEFAULT (getutcdate()) NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Genre_sysChangedAtUTC] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED ([GenreId] ASC)
);
GO

CREATE TABLE [dbo].[Reader] 
(
    [ReaderId]        INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]       NVARCHAR (255)                     NULL,
    [LastName]        NVARCHAR (255)                     NULL,
    [PersonId]        INT                                NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Reader_sysCreatedAtUTC] DEFAULT (getutcdate()) NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Reader_sysChangedAtUTC] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_Reader] PRIMARY KEY CLUSTERED ([ReaderId] ASC)
   ,CONSTRAINT [FK_Person_PersonId] FOREIGN KEY([PersonId]) REFERENCES [dbo].[Person]([PersonId])
);
GO

CREATE TABLE [dbo].[Author] 
(
    [AuthorId]        INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]       NVARCHAR (255)                     NULL,
    [LastName]        NVARCHAR (255)                     NULL,
    [PersonId]        INT                                NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Author_sysCreatedAtUTC] DEFAULT (getutcdate()) NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Author_sysChangedAtUTC] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_Author] PRIMARY KEY CLUSTERED ([AuthorId] ASC)
   ,CONSTRAINT [FK_Person_PersonId] FOREIGN KEY([PersonId]) REFERENCES [dbo].[Person]([PersonId]) 
);
GO

CREATE TABLE [dbo].[Work] 
(
    [WorkId]          INT            IDENTITY (1, 1) NOT NULL,
    [WorkName]        NVARCHAR (255)                     NULL,
    [AuthorId]        INT                                NULL,
    [GenreId]         INT                                NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Work_sysCreatedAtUTC] DEFAULT (getutcdate()) NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Work_sysChangedAtUTC] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_Work] PRIMARY KEY CLUSTERED ([WorkId] ASC)
   ,CONSTRAINT [FK_Author_AuthorId] FOREIGN KEY([AuthorId]) REFERENCES [dbo].[Author]([AuthorId]) 
   ,CONSTRAINT [FK_Genre_GenreId]   FOREIGN KEY([GenreId])  REFERENCES [dbo].[Genre]([GenreId])
);
GO

CREATE TABLE [dbo].[Book] 
(
    [BookId]          INT            IDENTITY (1, 1) NOT NULL,
    [BookName]        NVARCHAR (255)                     NULL,
    [LastName]        NVARCHAR (255)                     NULL,
    [AuthorId]        INT                                NULL,--?
    [WorkId]          INT                                NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_Book_sysCreatedAtUTC] DEFAULT (getutcdate()) NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_Book_sysChangedAtUTC] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED ([BookId] ASC)
   ,CONSTRAINT [FK_Author_AuthorId] FOREIGN KEY([AuthorId]) REFERENCES [dbo].[Author]([AuthorId]) 
   ,CONSTRAINT [FK_Work_WorkId]     FOREIGN KEY([WorkId])   REFERENCES [dbo].[Work]([WorkId])
);
GO

CREATE TABLE [dbo].[LibraryStaff] (
    [LibraryStaffId]        INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]             NVARCHAR (255)                     NULL,
    [LastName]              NVARCHAR (255)                     NULL,
    [PersonId]              INT                                NULL,
    [sysCreatedAtUTC]       DATETIME       CONSTRAINT [DF_LibraryStaff_sysCreatedAtUTC] DEFAULT (getutcdate()) NULL,
    [sysChangedAtUTC]       DATETIME       CONSTRAINT [DF_LibraryStaff_sysChangedAtUTC] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_LibraryStaff] PRIMARY KEY CLUSTERED ([LibraryStaffId] ASC)
   ,CONSTRAINT [FK_Person_PersonId] FOREIGN KEY([PersonId]) REFERENCES [dbo].[Person]([PersonId])
);
GO

CREATE TABLE [dbo].[LibraryOrder] (
    [LibraryOrderId]        INT            IDENTITY (1, 1) NOT NULL,
    [LibraryStaffId]        INT            NULL,
    [ReaderId]              INT            NULL,
    [BookId]                INT            NULL,
    [AuthorId]              INT            NULL,
    [sysCreatedAtUTC]       DATETIME       CONSTRAINT [DF_LibraryOrder_sysCreatedAtUTC] DEFAULT (getutcdate()) NULL,
    [sysChangedAtUTC]       DATETIME       CONSTRAINT [DF_LibraryOrder_sysChangedAtUTC] DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_LibraryOrder] PRIMARY KEY CLUSTERED ([LibraryOrderId] ASC)
   ,CONSTRAINT [FK_Reader_ReaderId] FOREIGN KEY([ReaderId]) REFERENCES [dbo].[Reader]([ReaderId])
   ,CONSTRAINT [FK_Book_BookId]     FOREIGN KEY([BookId])   REFERENCES [dbo].[Book]([BookId]) 
   ,CONSTRAINT [FK_Author_AuthorId] FOREIGN KEY([AuthorId]) REFERENCES [dbo].[Author]([AuthorId]) 
);
GO