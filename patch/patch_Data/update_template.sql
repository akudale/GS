USE [SlickTicket]

ALTER TABLE dbo.comments
  ADD assigned_to INT NOT NULL REFERENCES sub_units(id) DEFAULT _REPLACE_;

ALTER TABLE dbo.comments
  ADD priority_id INT NOT NULL REFERENCES priority(id) DEFAULT 1;

ALTER TABLE dbo.comments
  ADD status_id INT NOT NULL REFERENCES statuses(id) DEFAULT 1;
  
ALTER TABLE dbo.comments
  ADD active BIT NOT NULL DEFAULT 1;
  
ALTER TABLE dbo.tickets
  ADD active BIT NOT NULL DEFAULT 1;
  
ALTER TABLE dbo.attachments
  ADD active BIT NOT NULL DEFAULT 1;  
  
ALTER TABLE dbo.allowed_email_domains
  ALTER COLUMN domain NVARCHAR(100) NOT NULL;
  
ALTER TABLE dbo.attachments
  ALTER COLUMN attachment_name NVARCHAR(100) NOT NULL;
ALTER TABLE dbo.attachments
  ALTER COLUMN attachment_size NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.comments
  ALTER COLUMN comment NVARCHAR(MAX) NOT NULL;

ALTER TABLE dbo.faq
  ALTER COLUMN title NVARCHAR(MAX) NOT NULL;
ALTER TABLE dbo.faq
  ALTER COLUMN body NVARCHAR(MAX) NOT NULL;
  
ALTER TABLE dbo.priority
  ALTER COLUMN priority_name NVARCHAR(50) NOT NULL;
  
ALTER TABLE dbo.security_levels
  ALTER COLUMN security_level_name NVARCHAR(50) NOT NULL;
  
ALTER TABLE dbo.statuses
  ALTER COLUMN status_name NVARCHAR(50) NOT NULL;
  
ALTER TABLE dbo.styles
  ALTER COLUMN style_name NVARCHAR(50) NOT NULL;

GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[styles]') AND name = N'UQ__styles__0EA330E9')
ALTER TABLE [dbo].[styles] DROP CONSTRAINT [UQ__styles__0EA330E9]
GO

ALTER TABLE dbo.styles
  ALTER COLUMN style_name NVARCHAR(50) NOT NULL;
ALTER TABLE dbo.styles
ADD UNIQUE (style_name);
  
ALTER TABLE dbo.sub_units
  ALTER COLUMN sub_unit_name NVARCHAR(MAX) NOT NULL;
ALTER TABLE dbo.sub_units
  ALTER COLUMN mailto NVARCHAR(100) NOT NULL;
  
ALTER TABLE dbo.tickets
  ALTER COLUMN title NVARCHAR(100) NOT NULL;
ALTER TABLE dbo.tickets
  ALTER COLUMN details NVARCHAR(MAX) NOT NULL;
  
ALTER TABLE dbo.units
  ALTER COLUMN unit_name NVARCHAR(MAX) NOT NULL;
  
ALTER TABLE dbo.user_groups
  ALTER COLUMN ad_group NVARCHAR(100) NOT NULL;
  
ALTER TABLE dbo.users
  ALTER COLUMN userName NVARCHAR(MAX) NOT NULL;
ALTER TABLE dbo.users
  ALTER COLUMN phone NVARCHAR(20) NOT NULL;
ALTER TABLE dbo.users
  ALTER COLUMN email NVARCHAR(MAX) NOT NULL;
  
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[errors](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[title] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[details] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[occured] [datetime] NOT NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[Mailboxes]    Script Date: 12/03/2009 13:36:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mailboxes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SubUnitID] [int] NOT NULL,
	[Host] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmailAddress] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UserName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Password] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Port] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[EmailAddress] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Mailboxes]  WITH CHECK ADD FOREIGN KEY([SubUnitID])
REFERENCES [dbo].[sub_units] ([id])