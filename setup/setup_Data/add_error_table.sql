USE [SlickTicket]
GO

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