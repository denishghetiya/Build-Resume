USE [master]
GO
/****** Object:  Database [BuildResume]    Script Date: 05-10-2026 16:08:02 ******/
CREATE DATABASE [BuildResume]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BuildResume', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER1\MSSQL\DATA\BuildResume.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BuildResume_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER1\MSSQL\DATA\BuildResume_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BuildResume] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BuildResume].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BuildResume] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BuildResume] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BuildResume] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BuildResume] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BuildResume] SET ARITHABORT OFF 
GO
ALTER DATABASE [BuildResume] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BuildResume] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BuildResume] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BuildResume] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BuildResume] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BuildResume] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BuildResume] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BuildResume] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BuildResume] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BuildResume] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BuildResume] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BuildResume] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BuildResume] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BuildResume] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BuildResume] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BuildResume] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BuildResume] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BuildResume] SET RECOVERY FULL 
GO
ALTER DATABASE [BuildResume] SET  MULTI_USER 
GO
ALTER DATABASE [BuildResume] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BuildResume] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BuildResume] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BuildResume] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BuildResume] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BuildResume] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BuildResume', N'ON'
GO
ALTER DATABASE [BuildResume] SET QUERY_STORE = ON
GO
ALTER DATABASE [BuildResume] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BuildResume]
GO
/****** Object:  Table [dbo].[Experiences]    Script Date: 05-10-2026 16:08:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Experiences](
	[ExperienceId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[CompanyName] [nvarchar](max) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Role] [nvarchar](max) NOT NULL,
	[ExperienceInYear] [decimal](18, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Experiences] PRIMARY KEY CLUSTERED 
(
	[ExperienceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectLanguages]    Script Date: 05-10-2026 16:08:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectLanguages](
	[ProjectLanguageId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectLanguageName] [nvarchar](max) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectLanguages] PRIMARY KEY CLUSTERED 
(
	[ProjectLanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Projects]    Script Date: 05-10-2026 16:08:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Projects](
	[ProjectId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[ExperienceId] [int] NULL,
	[ProjectName] [nvarchar](max) NOT NULL,
	[Role] [nvarchar](max) NOT NULL,
	[TechnologyNames] [nvarchar](max) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjLangDetails]    Script Date: 05-10-2026 16:08:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjLangDetails](
	[ProjLangDetailId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[ProjectId] [int] NULL,
	[ProjectLanguageId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ProjLangDetails] PRIMARY KEY CLUSTERED 
(
	[ProjLangDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 05-10-2026 16:08:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NOT NULL,
	[LastName] [nvarchar](max) NOT NULL,
	[PhoneNumber] [bigint] NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Template] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Experiences] ON 
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (65, 107, N'w1', CAST(N'2025-09-24T00:00:00.000' AS DateTime), CAST(N'2025-09-28T00:00:00.000' AS DateTime), N'w1', NULL, 1)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (66, 107, N'w2', CAST(N'2025-10-01T00:00:00.000' AS DateTime), CAST(N'2025-10-05T00:00:00.000' AS DateTime), N'w2', NULL, 1)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (67, 107, N'w3', CAST(N'2025-09-25T00:00:00.000' AS DateTime), CAST(N'2025-10-02T00:00:00.000' AS DateTime), N'w3', CAST(0.02 AS Decimal(18, 2)), 1)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (68, 107, N'w5', CAST(N'2025-10-03T00:00:00.000' AS DateTime), CAST(N'2025-10-07T00:00:00.000' AS DateTime), N'w5', CAST(0.01 AS Decimal(18, 2)), 1)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (69, 108, N't', CAST(N'2024-01-01T00:00:00.000' AS DateTime), CAST(N'2025-01-01T00:00:00.000' AS DateTime), N't', CAST(1.00 AS Decimal(18, 2)), 1)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (70, 108, N'r', CAST(N'2025-02-01T00:00:00.000' AS DateTime), CAST(N'2025-07-02T00:00:00.000' AS DateTime), N'r', CAST(0.41 AS Decimal(18, 2)), 1)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (71, 108, N'r3', CAST(N'2025-08-01T00:00:00.000' AS DateTime), CAST(N'2025-10-07T00:00:00.000' AS DateTime), N'r3', CAST(0.18 AS Decimal(18, 2)), 1)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (72, 109, N'dd', CAST(N'2022-02-01T00:00:00.000' AS DateTime), CAST(N'2024-12-01T00:00:00.000' AS DateTime), N'd', CAST(2.83 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (73, 109, N'g', CAST(N'2025-09-27T00:00:00.000' AS DateTime), CAST(N'2025-10-01T00:00:00.000' AS DateTime), N'g', CAST(0.01 AS Decimal(18, 2)), 1)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (74, 110, N'abc', CAST(N'2025-10-01T00:00:00.000' AS DateTime), CAST(N'2025-10-10T00:00:00.000' AS DateTime), N'1', CAST(0.02 AS Decimal(18, 2)), 1)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (75, 111, N'd', CAST(N'2023-01-01T00:00:00.000' AS DateTime), CAST(N'2025-10-02T00:00:00.000' AS DateTime), N'd', CAST(2.75 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (76, 111, N'f', CAST(N'2025-10-05T00:00:00.000' AS DateTime), CAST(N'2025-10-10T00:00:00.000' AS DateTime), N'f', CAST(0.01 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (77, 112, N'Krista tech', CAST(N'2023-01-11T00:00:00.000' AS DateTime), CAST(N'2025-09-15T00:00:00.000' AS DateTime), N'JR', CAST(2.68 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (78, 112, N'a', CAST(N'2025-09-16T00:00:00.000' AS DateTime), CAST(N'2025-10-03T00:00:00.000' AS DateTime), N'aa', CAST(0.05 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (79, 112, N'b', CAST(N'2025-10-04T00:00:00.000' AS DateTime), CAST(N'2025-10-12T00:00:00.000' AS DateTime), N'b', CAST(0.02 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (80, 109, N'gg', CAST(N'2024-12-02T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), N'g', CAST(0.07 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (81, 113, N't1', CAST(N'2025-09-25T00:00:00.000' AS DateTime), CAST(N'2025-10-04T00:00:00.000' AS DateTime), N't', CAST(0.02 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (82, 113, N't2', CAST(N'2025-10-07T00:00:00.000' AS DateTime), CAST(N'2025-10-11T00:00:00.000' AS DateTime), N't', CAST(0.01 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (83, 114, N'a', CAST(N'2025-05-14T00:00:00.000' AS DateTime), CAST(N'2025-08-28T00:00:00.000' AS DateTime), N'd', CAST(0.29 AS Decimal(18, 2)), 0)
GO
INSERT [dbo].[Experiences] ([ExperienceId], [UserId], [CompanyName], [StartDate], [EndDate], [Role], [ExperienceInYear], [IsDeleted]) VALUES (84, 114, N'a', CAST(N'2025-09-25T00:00:00.000' AS DateTime), CAST(N'2025-10-13T00:00:00.000' AS DateTime), N'a', CAST(0.05 AS Decimal(18, 2)), 0)
GO
SET IDENTITY_INSERT [dbo].[Experiences] OFF
GO
SET IDENTITY_INSERT [dbo].[ProjectLanguages] ON 
GO
INSERT [dbo].[ProjectLanguages] ([ProjectLanguageId], [ProjectLanguageName], [IsDeleted]) VALUES (1, N'C#', 0)
GO
INSERT [dbo].[ProjectLanguages] ([ProjectLanguageId], [ProjectLanguageName], [IsDeleted]) VALUES (2, N'C++', 0)
GO
INSERT [dbo].[ProjectLanguages] ([ProjectLanguageId], [ProjectLanguageName], [IsDeleted]) VALUES (3, N'C', 0)
GO
INSERT [dbo].[ProjectLanguages] ([ProjectLanguageId], [ProjectLanguageName], [IsDeleted]) VALUES (4, N'Python', 0)
GO
SET IDENTITY_INSERT [dbo].[ProjectLanguages] OFF
GO
SET IDENTITY_INSERT [dbo].[Projects] ON 
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (134, NULL, 65, N'w11', N'w11', N'w11', CAST(N'2025-09-24T00:00:00.000' AS DateTime), CAST(N'2025-09-27T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (135, NULL, 66, N'w22', N'w22', N'w22', CAST(N'2025-10-02T00:00:00.000' AS DateTime), CAST(N'2025-10-04T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (136, NULL, 67, N'w33', N'w33', N'w33', CAST(N'2025-09-25T00:00:00.000' AS DateTime), CAST(N'2025-09-28T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (137, NULL, 67, N'w35', N'w35', N'w35', CAST(N'2025-09-29T00:00:00.000' AS DateTime), CAST(N'2025-10-01T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (138, NULL, 68, N'w55', N'w55', N'w55', CAST(N'2025-10-03T00:00:00.000' AS DateTime), CAST(N'2025-10-06T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (139, NULL, 67, N'w39', N'w39', N'w39', CAST(N'2025-09-27T00:00:00.000' AS DateTime), CAST(N'2025-09-29T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (140, NULL, 69, N't', N't', N't', CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (141, NULL, 70, N'r', N'r', N'r', CAST(N'2025-06-19T00:00:00.000' AS DateTime), CAST(N'2025-06-27T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (142, NULL, 71, N'r3', N'r3', N'r3', CAST(N'2025-10-01T00:00:00.000' AS DateTime), CAST(N'2025-10-03T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (143, NULL, 72, N'd1', N'dd', N'dd', CAST(N'2024-11-11T00:00:00.000' AS DateTime), CAST(N'2024-11-18T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (144, NULL, 72, N'd2', N'dd', N'dd', CAST(N'2024-11-19T00:00:00.000' AS DateTime), CAST(N'2024-11-30T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (145, NULL, 73, N'g1', N'g1', N'g1', CAST(N'2025-09-28T00:00:00.000' AS DateTime), CAST(N'2025-09-29T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (146, NULL, 74, N'abc', N'abc', N'abc', CAST(N'2025-10-01T00:00:00.000' AS DateTime), CAST(N'2025-10-10T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (147, NULL, 75, N'd1', N'd1', N'd1', CAST(N'2025-09-25T00:00:00.000' AS DateTime), CAST(N'2025-09-28T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (148, NULL, 75, N'd2', N'd2', N'd2', CAST(N'2025-09-29T00:00:00.000' AS DateTime), CAST(N'2025-10-01T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (149, NULL, 76, N'f1', N'f1', N'f1', CAST(N'2025-10-05T00:00:00.000' AS DateTime), CAST(N'2025-10-07T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (150, NULL, 77, N'Motum', N'Backend', N'.net', CAST(N'2025-09-04T00:00:00.000' AS DateTime), CAST(N'2025-09-05T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (151, NULL, 77, N'K-flow', N'fullstack', N'.net', CAST(N'2025-09-06T00:00:00.000' AS DateTime), CAST(N'2025-09-07T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (152, NULL, 78, N'aa', N'a', N'a', CAST(N'2025-09-22T00:00:00.000' AS DateTime), CAST(N'2025-09-23T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (153, NULL, 77, N't', N't', N't', CAST(N'2025-09-08T00:00:00.000' AS DateTime), CAST(N'2025-09-09T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (154, NULL, 78, N'r', N'r', N'r', CAST(N'2025-09-22T00:00:00.000' AS DateTime), CAST(N'2025-09-23T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (155, NULL, 78, N'tt', N'tt', N'tt', CAST(N'2025-09-24T00:00:00.000' AS DateTime), CAST(N'2025-09-25T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (156, NULL, 78, N'ttt', N'ttt', N'ttt', CAST(N'2025-09-26T00:00:00.000' AS DateTime), CAST(N'2025-09-27T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (157, NULL, 78, N'asd', N'asd', N'asd', CAST(N'2025-10-01T00:00:00.000' AS DateTime), CAST(N'2025-10-02T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (158, NULL, 79, N'b', N'b', N'b', CAST(N'2025-10-07T00:00:00.000' AS DateTime), CAST(N'2025-10-10T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (159, NULL, 80, N'g', N'g', N'g', CAST(N'2024-12-02T00:00:00.000' AS DateTime), CAST(N'2024-12-13T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (160, NULL, 81, N't', N't', N't', CAST(N'2025-09-25T00:00:00.000' AS DateTime), CAST(N'2025-10-02T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (161, NULL, 82, N't', N't', N't', CAST(N'2025-10-09T00:00:00.000' AS DateTime), CAST(N'2025-10-10T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (162, NULL, 83, N'a', N'a', N'a', CAST(N'2025-06-11T00:00:00.000' AS DateTime), CAST(N'2025-07-11T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Projects] ([ProjectId], [UserId], [ExperienceId], [ProjectName], [Role], [TechnologyNames], [StartDate], [EndDate], [IsDeleted]) VALUES (163, NULL, 84, N'a', N'a', N'a', CAST(N'2025-10-01T00:00:00.000' AS DateTime), CAST(N'2025-10-10T00:00:00.000' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[Projects] OFF
GO
SET IDENTITY_INSERT [dbo].[ProjLangDetails] ON 
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (142, NULL, 134, 2, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (143, NULL, 135, 2, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (144, NULL, 136, 3, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (145, NULL, 137, 4, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (146, NULL, 138, 1, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (147, NULL, 139, 2, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (148, NULL, 140, 1, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (149, NULL, 141, 2, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (150, NULL, 142, 3, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (151, NULL, 143, 1, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (152, NULL, 144, 2, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (153, NULL, 145, 3, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (154, NULL, 146, 1, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (155, NULL, 147, 1, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (156, NULL, 148, 2, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (157, NULL, 149, 3, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (158, NULL, 150, 1, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (159, NULL, 150, 2, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (160, NULL, 151, 1, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (161, NULL, 152, 1, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (162, NULL, 153, 1, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (163, NULL, 154, 1, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (164, NULL, 155, 1, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (165, NULL, 156, 1, 1)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (166, NULL, 157, 1, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (167, NULL, 158, 2, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (168, NULL, 159, 3, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (169, NULL, 160, 3, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (170, NULL, 161, 4, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (171, NULL, 162, 1, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (172, NULL, 163, 1, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (173, NULL, 162, 2, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (174, NULL, 162, 3, 0)
GO
INSERT [dbo].[ProjLangDetails] ([ProjLangDetailId], [UserId], [ProjectId], [ProjectLanguageId], [IsDeleted]) VALUES (175, NULL, 163, 4, 0)
GO
SET IDENTITY_INSERT [dbo].[ProjLangDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([UserId], [FirstName], [LastName], [PhoneNumber], [Email], [Template], [IsDeleted]) VALUES (107, N'Denish', N'G', 1234566666, N'd@gmail.com', NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [FirstName], [LastName], [PhoneNumber], [Email], [Template], [IsDeleted]) VALUES (108, N'test', N'test', 13234567890, N'tw@gmail.com', NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [FirstName], [LastName], [PhoneNumber], [Email], [Template], [IsDeleted]) VALUES (109, N'Denish', N'Ghetiya', 1234567890, N'denish@gmail.com', NULL, 0)
GO
INSERT [dbo].[Users] ([UserId], [FirstName], [LastName], [PhoneNumber], [Email], [Template], [IsDeleted]) VALUES (110, N'Kamani', N'Hardik', 9999999999, N'hardik@gmail.com', NULL, 1)
GO
INSERT [dbo].[Users] ([UserId], [FirstName], [LastName], [PhoneNumber], [Email], [Template], [IsDeleted]) VALUES (111, N'D', N'G', 12312323123, N'dg@gmail.com', NULL, 0)
GO
INSERT [dbo].[Users] ([UserId], [FirstName], [LastName], [PhoneNumber], [Email], [Template], [IsDeleted]) VALUES (112, N'Ronak', N'Patel', 7069825123, N'ronak@gmail.com', NULL, 0)
GO
INSERT [dbo].[Users] ([UserId], [FirstName], [LastName], [PhoneNumber], [Email], [Template], [IsDeleted]) VALUES (113, N'test', N'test', 98778899987, N'test@gmail.com', NULL, 0)
GO
INSERT [dbo].[Users] ([UserId], [FirstName], [LastName], [PhoneNumber], [Email], [Template], [IsDeleted]) VALUES (114, N'd', N'p', 1234567890, N'test@mailinator.com', N'_Template2', 0)
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
ALTER TABLE [dbo].[Experiences]  WITH CHECK ADD  CONSTRAINT [fk_Experience_UserId_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Experiences] CHECK CONSTRAINT [fk_Experience_UserId_Users_UserId]
GO
ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [fk_Projects_ExperienceId_Experiences_ExperienceId] FOREIGN KEY([ExperienceId])
REFERENCES [dbo].[Experiences] ([ExperienceId])
GO
ALTER TABLE [dbo].[Projects] CHECK CONSTRAINT [fk_Projects_ExperienceId_Experiences_ExperienceId]
GO
ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [fk_Projects_UserId_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Projects] CHECK CONSTRAINT [fk_Projects_UserId_Users_UserId]
GO
ALTER TABLE [dbo].[ProjLangDetails]  WITH CHECK ADD  CONSTRAINT [fk_ProjLangDetails_ProjectId_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjLangDetails] CHECK CONSTRAINT [fk_ProjLangDetails_ProjectId_Projects_ProjectId]
GO
ALTER TABLE [dbo].[ProjLangDetails]  WITH CHECK ADD  CONSTRAINT [fk_ProjLangDetails_ProjectLanguageId_ProjectLanguages_ProjectLanguageId] FOREIGN KEY([ProjectLanguageId])
REFERENCES [dbo].[ProjectLanguages] ([ProjectLanguageId])
GO
ALTER TABLE [dbo].[ProjLangDetails] CHECK CONSTRAINT [fk_ProjLangDetails_ProjectLanguageId_ProjectLanguages_ProjectLanguageId]
GO
ALTER TABLE [dbo].[ProjLangDetails]  WITH CHECK ADD  CONSTRAINT [fk_ProjLangDetails_UserId_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[ProjLangDetails] CHECK CONSTRAINT [fk_ProjLangDetails_UserId_Users_UserId]
GO
USE [master]
GO
ALTER DATABASE [BuildResume] SET  READ_WRITE 
GO
