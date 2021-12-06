CREATE TABLE [dbo].[LibraryStaff] (
    [LibraryStaffId]  INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]       NVARCHAR (255) NULL,
    [LastName]        NVARCHAR (255) NULL,
    [PersonId]        INT            NULL,
    [sysCreatedAtUTC] DATETIME       CONSTRAINT [DF_LibraryStaff_sysCreatedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    [sysChangedAtUTC] DATETIME       CONSTRAINT [DF_LibraryStaff_sysChangedAtUTC] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_LibraryStaff] PRIMARY KEY CLUSTERED ([LibraryStaffId] ASC),
    CONSTRAINT [FK_LibraryStaff_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
);

