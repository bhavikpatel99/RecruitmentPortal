use master
GO
/****** Object:  Database [RecruitmentPortal_Demo]    Script Date: 14-09-2026 1.52.24 AM ******/
CREATE DATABASE [RecruitmentPortal_Demo]
GO
USE [RecruitmentPortal_Demo]
GO
/****** Object:  Table [dbo].[Agencies]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Agencies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[ContactEmail] [nvarchar](256) NULL,
	[ContactPhone] [nvarchar](30) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AgencySubmissions]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AgencySubmissions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AgencyId] [int] NOT NULL,
	[JobId] [int] NULL,
	[CandidateId] [int] NULL,
	[SubmittedBy] [int] NOT NULL,
	[SubmittedAt] [datetime2](7) NOT NULL,
	[WasDuplicate] [bit] NOT NULL,
	[DuplicateOfCandidateId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApprovalMatrices]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApprovalMatrices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[MinAmount] [decimal](18, 2) NULL,
	[MaxAmount] [decimal](18, 2) NULL,
	[RequiredApproverRole] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssessmentInvitations]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssessmentInvitations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateId] [int] NOT NULL,
	[AssessmentTemplateId] [int] NOT NULL,
	[InvitedBy] [int] NULL,
	[InvitedAt] [datetime2](7) NOT NULL,
	[Deadline] [datetime2](7) NULL,
	[Status] [nvarchar](30) NOT NULL,
	[Score] [int] NULL,
	[PassFail] [nvarchar](10) NULL,
	[CompletedAt] [datetime2](7) NULL,
	[Notes] [nvarchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssessmentTemplates]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssessmentTemplates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[AssessmentType] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[VendorName] [nvarchar](150) NULL,
	[ExternalLink] [nvarchar](500) NULL,
	[PassingScore] [int] NULL,
	[DurationMinutes] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CandidateNotes]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CandidateNotes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateId] [int] NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Candidates]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Candidates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[JobId] [int] NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[MiddleName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[Phone] [nvarchar](20) NULL,
	[AlternatePhone] [nvarchar](20) NULL,
	[DateOfBirth] [datetime2](7) NULL,
	[Gender] [nvarchar](50) NULL,
	[MaritalStatus] [nvarchar](50) NULL,
	[Nationality] [nvarchar](100) NULL,
	[Address] [nvarchar](500) NULL,
	[City] [nvarchar](100) NULL,
	[State] [nvarchar](100) NULL,
	[Country] [nvarchar](100) NULL,
	[PostalCode] [nvarchar](20) NULL,
	[PositionApplied] [nvarchar](150) NULL,
	[EmploymentType] [nvarchar](100) NULL,
	[TotalExperience] [decimal](5, 2) NULL,
	[CurrentCompany] [nvarchar](150) NULL,
	[CurrentCtc] [decimal](18, 2) NULL,
	[ExpectedCtc] [decimal](18, 2) NULL,
	[NoticePeriodDays] [int] NULL,
	[PreferredLocation] [nvarchar](150) NULL,
	[WillingToRelocate] [bit] NULL,
	[AvailableFrom] [datetime2](7) NULL,
	[HighestQualification] [nvarchar](150) NULL,
	[Skills] [nvarchar](max) NULL,
	[LinkedInUrl] [nvarchar](300) NULL,
	[PortfolioUrl] [nvarchar](300) NULL,
	[GitHubUrl] [nvarchar](300) NULL,
	[ResumeUrl] [nvarchar](300) NULL,
	[CoverLetter] [nvarchar](max) NULL,
	[ReferenceName] [nvarchar](150) NULL,
	[ReferenceContact] [nvarchar](150) NULL,
	[Source] [nvarchar](100) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[ResumeFileName] [nvarchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CandidateStageHistory]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CandidateStageHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateId] [int] NOT NULL,
	[FromStatus] [nvarchar](50) NULL,
	[ToStatus] [nvarchar](50) NOT NULL,
	[ChangedBy] [int] NULL,
	[Reason] [nvarchar](200) NULL,
	[Notes] [nvarchar](max) NULL,
	[ChangedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CandidateTags]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CandidateTags](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateId] [int] NOT NULL,
	[Tag] [nvarchar](50) NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Competencies]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Competencies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Countries]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Countries](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Code] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departments]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailLog]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ToEmail] [nvarchar](256) NOT NULL,
	[Subject] [nvarchar](300) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[TemplateCode] [nvarchar](80) NULL,
	[CandidateId] [int] NULL,
	[Status] [nvarchar](20) NOT NULL,
	[ErrorMessage] [nvarchar](1000) NULL,
	[SentBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[SentAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailTemplates]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailTemplates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](80) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Subject] [nvarchar](300) NOT NULL,
	[BodyHtml] [nvarchar](max) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[IsSystem] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HireEvents]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HireEvents](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateId] [int] NOT NULL,
	[OfferId] [int] NOT NULL,
	[Payload] [nvarchar](max) NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[SentAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InterviewFeedback]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterviewFeedback](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InterviewId] [int] NOT NULL,
	[InterviewerId] [int] NOT NULL,
	[Rating] [int] NULL,
	[Recommendation] [nvarchar](50) NULL,
	[Strengths] [nvarchar](max) NULL,
	[Concerns] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[SubmittedAt] [datetime2](7) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InterviewPanelists]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterviewPanelists](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InterviewId] [int] NOT NULL,
	[InterviewerId] [int] NOT NULL,
	[IsLead] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InterviewPanelMasterMembers]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterviewPanelMasterMembers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PanelId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InterviewPanelsMaster]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterviewPanelsMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Interviews]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Interviews](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateId] [int] NOT NULL,
	[JobId] [int] NULL,
	[RoundNumber] [int] NOT NULL,
	[InterviewType] [nvarchar](100) NULL,
	[ScheduledAt] [datetime2](7) NULL,
	[DurationMinutes] [int] NULL,
	[Mode] [nvarchar](50) NULL,
	[MeetingLink] [nvarchar](500) NULL,
	[Location] [nvarchar](300) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[CancellationReason] [nvarchar](500) NULL,
	[ScheduledBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobFamilies]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobFamilies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobPostingChannels]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobPostingChannels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[Channel] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[ExternalUrl] [nvarchar](500) NULL,
	[PostedAt] [datetime2](7) NOT NULL,
	[ExpiryDate] [datetime2](7) NULL,
	[CreatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobRequisitionAudit]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobRequisitionAudit](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JobRequisitionId] [int] NOT NULL,
	[Action] [nvarchar](50) NOT NULL,
	[FromStatus] [nvarchar](50) NULL,
	[ToStatus] [nvarchar](50) NULL,
	[PerformedBy] [int] NULL,
	[Notes] [nvarchar](500) NULL,
	[PerformedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobRequisitions]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobRequisitions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Department] [nvarchar](256) NOT NULL,
	[Location] [nvarchar](256) NOT NULL,
	[EmploymentType] [nvarchar](100) NULL,
	[Vacancies] [int] NOT NULL,
	[Priority] [nvarchar](50) NOT NULL,
	[RequisitionType] [nvarchar](50) NOT NULL,
	[TargetJoiningDate] [datetime2](7) NULL,
	[BudgetReference] [nvarchar](200) NULL,
	[JustificationNotes] [nvarchar](max) NULL,
	[RequiredSkills] [nvarchar](max) NULL,
	[HiringManagerId] [int] NULL,
	[RecruiterId] [int] NULL,
	[JobId] [int] NULL,
	[Status] [nvarchar](50) NOT NULL,
	[ApprovedBy] [int] NULL,
	[ApprovedAt] [datetime2](7) NULL,
	[RejectionReason] [nvarchar](500) NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Jobs]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jobs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Requirements] [nvarchar](max) NULL,
	[Responsibilities] [nvarchar](max) NULL,
	[Location] [nvarchar](256) NOT NULL,
	[EmploymentType] [nvarchar](100) NULL,
	[SalaryMin] [decimal](18, 2) NULL,
	[SalaryMax] [decimal](18, 2) NULL,
	[ExperienceYearsMin] [int] NULL,
	[ExperienceYearsMax] [int] NULL,
	[Skills] [nvarchar](max) NULL,
	[Department] [nvarchar](256) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[PostedDate] [datetime2](7) NOT NULL,
	[ClosedDate] [datetime2](7) NULL,
	[PostedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[MustHaveSkills] [nvarchar](max) NULL,
	[NiceToHaveSkills] [nvarchar](max) NULL,
	[EducationRequirement] [nvarchar](300) NULL,
	[WorkMode] [nvarchar](30) NULL,
	[BenefitsText] [nvarchar](max) NULL,
	[LegalText] [nvarchar](max) NULL,
	[JobRequisitionId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lookups]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lookups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Category] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OfferAudit]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OfferAudit](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OfferId] [int] NOT NULL,
	[Action] [nvarchar](50) NOT NULL,
	[FromStatus] [nvarchar](30) NULL,
	[ToStatus] [nvarchar](30) NULL,
	[PerformedBy] [int] NULL,
	[Notes] [nvarchar](1000) NULL,
	[PerformedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Offers]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Offers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateId] [int] NOT NULL,
	[JobId] [int] NULL,
	[BaseSalary] [decimal](18, 2) NOT NULL,
	[Bonus] [decimal](18, 2) NULL,
	[EquityDetails] [nvarchar](300) NULL,
	[OtherBenefits] [nvarchar](1000) NULL,
	[TotalCtc] [decimal](18, 2) NULL,
	[ValidUntil] [datetime2](7) NULL,
	[Status] [nvarchar](30) NOT NULL,
	[SignedDocumentUrl] [nvarchar](500) NULL,
	[ApprovedBy] [int] NULL,
	[ApprovedAt] [datetime2](7) NULL,
	[SentAt] [datetime2](7) NULL,
	[RespondedAt] [datetime2](7) NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OfficeLocations]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OfficeLocations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[City] [nvarchar](100) NULL,
	[Country] [nvarchar](100) NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PreJoiningChecklists]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreJoiningChecklists](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateId] [int] NOT NULL,
	[OfferId] [int] NOT NULL,
	[JoiningDate] [datetime2](7) NULL,
	[BgvStatus] [nvarchar](30) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PreJoiningTasks]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreJoiningTasks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ChecklistId] [int] NOT NULL,
	[TaskName] [nvarchar](200) NOT NULL,
	[IsCompleted] [bit] NOT NULL,
	[CompletedAt] [datetime2](7) NULL,
	[Notes] [nvarchar](500) NULL,
	[SortOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Referrals]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Referrals](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReferrerUserId] [int] NOT NULL,
	[JobId] [int] NOT NULL,
	[CandidateId] [int] NULL,
	[ReferralCode] [nvarchar](20) NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
	[BonusAmount] [decimal](18, 2) NULL,
	[BonusStatus] [nvarchar](20) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SalaryBands]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalaryBands](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JobFamilyId] [int] NULL,
	[Level] [nvarchar](100) NOT NULL,
	[MinSalary] [decimal](18, 2) NOT NULL,
	[MaxSalary] [decimal](18, 2) NOT NULL,
	[Currency] [nvarchar](10) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SavedSearches]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SavedSearches](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Keyword] [nvarchar](200) NULL,
	[MinExperience] [decimal](5, 2) NULL,
	[MaxExperience] [decimal](5, 2) NULL,
	[Location] [nvarchar](150) NULL,
	[Status] [nvarchar](50) NULL,
	[Source] [nvarchar](100) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScreeningAnswers]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScreeningAnswers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ScreeningResponseId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[AnswerText] [nvarchar](max) NULL,
	[PassedKnockout] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScreeningForms]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScreeningForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScreeningQuestions]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScreeningQuestions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ScreeningFormId] [int] NOT NULL,
	[QuestionText] [nvarchar](500) NOT NULL,
	[QuestionType] [nvarchar](30) NOT NULL,
	[Options] [nvarchar](500) NULL,
	[IsKnockout] [bit] NOT NULL,
	[ExpectedAnswer] [nvarchar](200) NULL,
	[SortOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScreeningResponses]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScreeningResponses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateId] [int] NOT NULL,
	[ScreeningFormId] [int] NOT NULL,
	[SubmittedAt] [datetime2](7) NOT NULL,
	[KnockoutFailed] [bit] NOT NULL,
	[OverallScore] [int] NULL,
	[Recommendation] [nvarchar](20) NULL,
	[RecruiterNotes] [nvarchar](max) NULL,
	[EvaluatedBy] [int] NULL,
	[EvaluatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SkillsMaster]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SkillsMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Category] [nvarchar](100) NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SmtpSettings]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SmtpSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Provider] [nvarchar](50) NOT NULL,
	[Host] [nvarchar](200) NOT NULL,
	[Port] [int] NOT NULL,
	[SecureSocketMode] [nvarchar](20) NOT NULL,
	[Username] [nvarchar](256) NOT NULL,
	[EncryptedPassword] [nvarchar](max) NOT NULL,
	[FromEmail] [nvarchar](256) NOT NULL,
	[FromName] [nvarchar](150) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[States]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[States](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TalentPoolMembers]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TalentPoolMembers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TalentPoolId] [int] NOT NULL,
	[CandidateId] [int] NOT NULL,
	[AddedBy] [int] NULL,
	[AddedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TalentPools]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TalentPools](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[CreatedBy] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](256) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[PasswordHash] [nvarchar](max) NOT NULL,
	[Role] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[AgencyId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ApprovalMatrices] ON 
GO
INSERT [dbo].[ApprovalMatrices] ([Id], [Name], [Description], [MinAmount], [MaxAmount], [RequiredApproverRole], [IsActive]) VALUES (1, N'Standard Offer Approval', N'Offers up to 30L require Admin approval', CAST(0.00 AS Decimal(18, 2)), CAST(3000000.00 AS Decimal(18, 2)), N'Admin', 1)
GO
INSERT [dbo].[ApprovalMatrices] ([Id], [Name], [Description], [MinAmount], [MaxAmount], [RequiredApproverRole], [IsActive]) VALUES (2, N'Executive Offer Approval', N'Offers above 30L require Admin approval and additional review', CAST(3000001.00 AS Decimal(18, 2)), NULL, N'Admin', 1)
GO
SET IDENTITY_INSERT [dbo].[ApprovalMatrices] OFF
GO
SET IDENTITY_INSERT [dbo].[Candidates] ON 
GO
INSERT [dbo].[Candidates] ([Id], [UserId], [JobId], [FirstName], [MiddleName], [LastName], [Email], [Phone], [AlternatePhone], [DateOfBirth], [Gender], [MaritalStatus], [Nationality], [Address], [City], [State], [Country], [PostalCode], [PositionApplied], [EmploymentType], [TotalExperience], [CurrentCompany], [CurrentCtc], [ExpectedCtc], [NoticePeriodDays], [PreferredLocation], [WillingToRelocate], [AvailableFrom], [HighestQualification], [Skills], [LinkedInUrl], [PortfolioUrl], [GitHubUrl], [ResumeUrl], [CoverLetter], [ReferenceName], [ReferenceContact], [Source], [Status], [CreatedAt], [UpdatedAt], [ResumeFileName]) VALUES (1, 4, NULL, N'Ananya', NULL, N'Rao', N'candidate1@example.com', N'+91-9876500001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Senior Backend Engineer', N'Full-time', CAST(6.50 AS Decimal(5, 2)), N'TechNova Ltd', CAST(2200000.00 AS Decimal(18, 2)), CAST(2600000.00 AS Decimal(18, 2)), 60, N'Bengaluru', 0, NULL, N'B.Tech Computer Science', N'C#, .NET, SQL Server, Azure, Microservices', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Job Portal', N'Shortlisted', CAST(N'2026-09-13T19:14:12.0389555' AS DateTime2), CAST(N'2026-09-13T19:47:48.5255715' AS DateTime2), NULL)
GO
INSERT [dbo].[Candidates] ([Id], [UserId], [JobId], [FirstName], [MiddleName], [LastName], [Email], [Phone], [AlternatePhone], [DateOfBirth], [Gender], [MaritalStatus], [Nationality], [Address], [City], [State], [Country], [PostalCode], [PositionApplied], [EmploymentType], [TotalExperience], [CurrentCompany], [CurrentCtc], [ExpectedCtc], [NoticePeriodDays], [PreferredLocation], [WillingToRelocate], [AvailableFrom], [HighestQualification], [Skills], [LinkedInUrl], [PortfolioUrl], [GitHubUrl], [ResumeUrl], [CoverLetter], [ReferenceName], [ReferenceContact], [Source], [Status], [CreatedAt], [UpdatedAt], [ResumeFileName]) VALUES (2, 5, 1, N'Karan', NULL, N'Patel', N'candidate2@example.com', N'+91-9876500002', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Senior Backend Engineer', N'Full-time', CAST(7.00 AS Decimal(5, 2)), N'CloudWorks Inc', CAST(2400000.00 AS Decimal(18, 2)), CAST(2900000.00 AS Decimal(18, 2)), 30, N'Bengaluru', 1, NULL, N'M.Tech Software Engineering', N'C#, .NET, SQL Server, Kubernetes', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Referral', N'Interview', CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2), CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2), NULL)
GO
INSERT [dbo].[Candidates] ([Id], [UserId], [JobId], [FirstName], [MiddleName], [LastName], [Email], [Phone], [AlternatePhone], [DateOfBirth], [Gender], [MaritalStatus], [Nationality], [Address], [City], [State], [Country], [PostalCode], [PositionApplied], [EmploymentType], [TotalExperience], [CurrentCompany], [CurrentCtc], [ExpectedCtc], [NoticePeriodDays], [PreferredLocation], [WillingToRelocate], [AvailableFrom], [HighestQualification], [Skills], [LinkedInUrl], [PortfolioUrl], [GitHubUrl], [ResumeUrl], [CoverLetter], [ReferenceName], [ReferenceContact], [Source], [Status], [CreatedAt], [UpdatedAt], [ResumeFileName]) VALUES (3, 6, 2, N'Sara', NULL, N'Khan', N'candidate3@example.com', N'+91-9876500003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Product Designer', N'Full-time', CAST(4.00 AS Decimal(5, 2)), N'PixelForge Studio', CAST(1500000.00 AS Decimal(18, 2)), CAST(1900000.00 AS Decimal(18, 2)), 45, N'Remote', 0, NULL, N'B.Des', N'Figma, Design Systems, Prototyping', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Company Website', N'Screening', CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2), CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2), NULL)
GO
INSERT [dbo].[Candidates] ([Id], [UserId], [JobId], [FirstName], [MiddleName], [LastName], [Email], [Phone], [AlternatePhone], [DateOfBirth], [Gender], [MaritalStatus], [Nationality], [Address], [City], [State], [Country], [PostalCode], [PositionApplied], [EmploymentType], [TotalExperience], [CurrentCompany], [CurrentCtc], [ExpectedCtc], [NoticePeriodDays], [PreferredLocation], [WillingToRelocate], [AvailableFrom], [HighestQualification], [Skills], [LinkedInUrl], [PortfolioUrl], [GitHubUrl], [ResumeUrl], [CoverLetter], [ReferenceName], [ReferenceContact], [Source], [Status], [CreatedAt], [UpdatedAt], [ResumeFileName]) VALUES (4, NULL, 2, N'Devika', NULL, N'Nair', N'devika.nair@example.com', N'+91-9876500004', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Product Designer', N'Full-time', CAST(3.00 AS Decimal(5, 2)), N'FreelanceDesign', NULL, CAST(1600000.00 AS Decimal(18, 2)), 15, N'Remote', 1, NULL, N'B.Des', N'Figma, Illustration', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Social Media', N'Applied', CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2), NULL, NULL)
GO
INSERT [dbo].[Candidates] ([Id], [UserId], [JobId], [FirstName], [MiddleName], [LastName], [Email], [Phone], [AlternatePhone], [DateOfBirth], [Gender], [MaritalStatus], [Nationality], [Address], [City], [State], [Country], [PostalCode], [PositionApplied], [EmploymentType], [TotalExperience], [CurrentCompany], [CurrentCtc], [ExpectedCtc], [NoticePeriodDays], [PreferredLocation], [WillingToRelocate], [AvailableFrom], [HighestQualification], [Skills], [LinkedInUrl], [PortfolioUrl], [GitHubUrl], [ResumeUrl], [CoverLetter], [ReferenceName], [ReferenceContact], [Source], [Status], [CreatedAt], [UpdatedAt], [ResumeFileName]) VALUES (5, NULL, 3, N'Rohit', NULL, N'Verma', N'rohit.verma@example.com', N'+91-9876500005', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'QA Engineer', N'Contract', CAST(2.00 AS Decimal(5, 2)), N'QAPro Services', NULL, CAST(1000000.00 AS Decimal(18, 2)), 30, N'Pune', 0, NULL, N'B.Sc IT', N'Manual Testing, Selenium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Walk-in', N'Rejected', CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2), CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2), NULL)
GO
SET IDENTITY_INSERT [dbo].[Candidates] OFF
GO
SET IDENTITY_INSERT [dbo].[CandidateStageHistory] ON 
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (1, 1, NULL, N'Applied', 4, N'Application submitted', NULL, CAST(N'2026-09-13T19:14:12.0389555' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (2, 1, N'Applied', N'Screening', 2, N'Strong resume match', NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (3, 1, N'Screening', N'Shortlisted', 2, N'Passed recruiter screen', NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (4, 2, NULL, N'Applied', 5, N'Application submitted', NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (5, 2, N'Applied', N'Screening', 2, NULL, NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (6, 2, N'Screening', N'Shortlisted', 2, NULL, NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (7, 2, N'Shortlisted', N'Interview', 2, N'Scheduled for technical round', NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (8, 3, NULL, N'Applied', 6, N'Application submitted', NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (9, 3, N'Applied', N'Screening', 2, NULL, NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (10, 4, NULL, N'Applied', NULL, N'Application submitted', NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (11, 5, NULL, N'Applied', NULL, N'Application submitted', NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
INSERT [dbo].[CandidateStageHistory] ([Id], [CandidateId], [FromStatus], [ToStatus], [ChangedBy], [Reason], [Notes], [ChangedAt]) VALUES (12, 5, N'Applied', N'Rejected', 2, N'Role closed before screening completed', NULL, CAST(N'2026-09-13T19:14:12.0471363' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[CandidateStageHistory] OFF
GO
SET IDENTITY_INSERT [dbo].[Competencies] ON 
GO
INSERT [dbo].[Competencies] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Communication', N'Clear written and verbal communication', 1)
GO
INSERT [dbo].[Competencies] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'Problem Solving', N'Structured approach to ambiguous problems', 1)
GO
INSERT [dbo].[Competencies] ([Id], [Name], [Description], [IsActive]) VALUES (3, N'Leadership', N'Influences and mentors others effectively', 1)
GO
SET IDENTITY_INSERT [dbo].[Competencies] OFF
GO
SET IDENTITY_INSERT [dbo].[Countries] ON 
GO
INSERT [dbo].[Countries] ([Id], [Name], [Code]) VALUES (1, N'India', N'IN')
GO
INSERT [dbo].[Countries] ([Id], [Name], [Code]) VALUES (2, N'United States', N'US')
GO
INSERT [dbo].[Countries] ([Id], [Name], [Code]) VALUES (3, N'United Kingdom', N'GB')
GO
INSERT [dbo].[Countries] ([Id], [Name], [Code]) VALUES (4, N'Canada', N'CA')
GO
INSERT [dbo].[Countries] ([Id], [Name], [Code]) VALUES (5, N'Australia', N'AU')
GO
SET IDENTITY_INSERT [dbo].[Countries] OFF
GO
SET IDENTITY_INSERT [dbo].[Departments] ON 
GO
INSERT [dbo].[Departments] ([Id], [Name], [IsActive]) VALUES (1, N'Engineering', 1)
GO
INSERT [dbo].[Departments] ([Id], [Name], [IsActive]) VALUES (2, N'Design', 1)
GO
INSERT [dbo].[Departments] ([Id], [Name], [IsActive]) VALUES (3, N'Analytics', 1)
GO
INSERT [dbo].[Departments] ([Id], [Name], [IsActive]) VALUES (4, N'Sales', 1)
GO
INSERT [dbo].[Departments] ([Id], [Name], [IsActive]) VALUES (5, N'Human Resources', 1)
GO
SET IDENTITY_INSERT [dbo].[Departments] OFF
GO
SET IDENTITY_INSERT [dbo].[EmailTemplates] ON 
GO
INSERT [dbo].[EmailTemplates] ([Id], [Code], [Name], [Subject], [BodyHtml], [Category], [IsSystem], [IsActive], [CreatedBy], [CreatedAt], [UpdatedAt]) VALUES (1, N'ApplicationReceived', N'Application Received', N'We received your application for {{JobTitle}}', N'<p>Hi {{FirstName}},</p><p>Thanks for applying for <strong>{{JobTitle}}</strong> at {{CompanyName}}. Our team will review your application and get back to you soon.</p><p>Best regards,<br/>{{CompanyName}} Recruiting Team</p>', N'Application', 1, 1, NULL, CAST(N'2026-09-13T19:13:53.0399123' AS DateTime2), NULL)
GO
INSERT [dbo].[EmailTemplates] ([Id], [Code], [Name], [Subject], [BodyHtml], [Category], [IsSystem], [IsActive], [CreatedBy], [CreatedAt], [UpdatedAt]) VALUES (2, N'InterviewScheduled', N'Interview Scheduled', N'Your interview for {{JobTitle}} is scheduled', N'<p>Hi {{FirstName}},</p><p>Your {{InterviewType}} interview for <strong>{{JobTitle}}</strong> is scheduled for <strong>{{ScheduledAt}}</strong>.</p><p>{{MeetingInfo}}</p><p>Good luck!<br/>{{CompanyName}} Recruiting Team</p>', N'Interview', 1, 1, NULL, CAST(N'2026-09-13T19:13:53.0399123' AS DateTime2), NULL)
GO
INSERT [dbo].[EmailTemplates] ([Id], [Code], [Name], [Subject], [BodyHtml], [Category], [IsSystem], [IsActive], [CreatedBy], [CreatedAt], [UpdatedAt]) VALUES (3, N'AssessmentInvitation', N'Assessment Invitation', N'You are invited to complete an assessment for {{JobTitle}}', N'<p>Hi {{FirstName}},</p><p>As the next step for <strong>{{JobTitle}}</strong>, please complete the {{AssessmentTitle}} assessment by <strong>{{Deadline}}</strong>.</p><p>{{AssessmentLink}}</p><p>Best regards,<br/>{{CompanyName}} Recruiting Team</p>', N'Assessment', 1, 1, NULL, CAST(N'2026-09-13T19:13:53.0399123' AS DateTime2), NULL)
GO
INSERT [dbo].[EmailTemplates] ([Id], [Code], [Name], [Subject], [BodyHtml], [Category], [IsSystem], [IsActive], [CreatedBy], [CreatedAt], [UpdatedAt]) VALUES (4, N'OfferSent', N'Offer Sent', N'Your offer from {{CompanyName}}', N'<p>Hi {{FirstName}},</p><p>Congratulations! We are delighted to offer you the position of <strong>{{JobTitle}}</strong> at {{CompanyName}}.</p><p>Base salary: {{BaseSalary}}<br/>Offer valid until: {{ValidUntil}}</p><p>Please review and respond at your earliest convenience.</p><p>Welcome aboard,<br/>{{CompanyName}} Recruiting Team</p>', N'Offer', 1, 1, NULL, CAST(N'2026-09-13T19:13:53.0399123' AS DateTime2), NULL)
GO
INSERT [dbo].[EmailTemplates] ([Id], [Code], [Name], [Subject], [BodyHtml], [Category], [IsSystem], [IsActive], [CreatedBy], [CreatedAt], [UpdatedAt]) VALUES (5, N'RejectionNotice', N'Application Update', N'Update on your application for {{JobTitle}}', N'<p>Hi {{FirstName}},</p><p>Thank you for your interest in <strong>{{JobTitle}}</strong> at {{CompanyName}} and for the time you invested in the process.</p><p>After careful consideration, we have decided to move forward with other candidates at this time. {{ReasonNote}}</p><p>We wish you the best in your job search.</p><p>Regards,<br/>{{CompanyName}} Recruiting Team</p>', N'Rejection', 1, 1, NULL, CAST(N'2026-09-13T19:13:53.0399123' AS DateTime2), NULL)
GO
INSERT [dbo].[EmailTemplates] ([Id], [Code], [Name], [Subject], [BodyHtml], [Category], [IsSystem], [IsActive], [CreatedBy], [CreatedAt], [UpdatedAt]) VALUES (6, N'ReferralInvite', N'Referral Confirmation', N'Thanks for your referral!', N'<p>Hi {{ReferrerName}},</p><p>Thanks for referring {{CandidateName}} for <strong>{{JobTitle}}</strong>. We will keep you posted on their progress.</p><p>{{CompanyName}} Recruiting Team</p>', N'Referral', 1, 1, NULL, CAST(N'2026-09-13T19:13:53.0399123' AS DateTime2), NULL)
GO
SET IDENTITY_INSERT [dbo].[EmailTemplates] OFF
GO
SET IDENTITY_INSERT [dbo].[InterviewFeedback] ON 
GO
INSERT [dbo].[InterviewFeedback] ([Id], [InterviewId], [InterviewerId], [Rating], [Recommendation], [Strengths], [Concerns], [Comments], [SubmittedAt], [CreatedAt]) VALUES (1, 1, 3, 4, N'Hire', N'Strong systems design, clear communicator.', N'Limited hands-on Kubernetes experience.', N'Would be a solid addition to the platform team.', CAST(N'2026-09-13T19:14:12.0601990' AS DateTime2), CAST(N'2026-09-13T19:14:12.0601990' AS DateTime2))
GO
INSERT [dbo].[InterviewFeedback] ([Id], [InterviewId], [InterviewerId], [Rating], [Recommendation], [Strengths], [Concerns], [Comments], [SubmittedAt], [CreatedAt]) VALUES (2, 1, 2, 4, N'Hire', NULL, NULL, N'Good culture fit, references check out.', CAST(N'2026-09-13T19:14:12.0612007' AS DateTime2), CAST(N'2026-09-13T19:14:12.0612007' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[InterviewFeedback] OFF
GO
SET IDENTITY_INSERT [dbo].[InterviewPanelists] ON 
GO
INSERT [dbo].[InterviewPanelists] ([Id], [InterviewId], [InterviewerId], [IsLead]) VALUES (1, 1, 3, 1)
GO
INSERT [dbo].[InterviewPanelists] ([Id], [InterviewId], [InterviewerId], [IsLead]) VALUES (2, 1, 2, 0)
GO
INSERT [dbo].[InterviewPanelists] ([Id], [InterviewId], [InterviewerId], [IsLead]) VALUES (3, 2, 3, 1)
GO
SET IDENTITY_INSERT [dbo].[InterviewPanelists] OFF
GO
SET IDENTITY_INSERT [dbo].[Interviews] ON 
GO
INSERT [dbo].[Interviews] ([Id], [CandidateId], [JobId], [RoundNumber], [InterviewType], [ScheduledAt], [DurationMinutes], [Mode], [MeetingLink], [Location], [Status], [CancellationReason], [ScheduledBy], [CreatedAt], [UpdatedAt]) VALUES (1, 2, 1, 1, N'Technical', CAST(N'2026-09-11T19:14:12.0059879' AS DateTime2), 60, N'Video', N'https://meet.example.com/interview-karan-r1', NULL, N'Completed', NULL, 2, CAST(N'2026-09-13T19:14:12.0541967' AS DateTime2), CAST(N'2026-09-13T19:14:12.0627475' AS DateTime2))
GO
INSERT [dbo].[Interviews] ([Id], [CandidateId], [JobId], [RoundNumber], [InterviewType], [ScheduledAt], [DurationMinutes], [Mode], [MeetingLink], [Location], [Status], [CancellationReason], [ScheduledBy], [CreatedAt], [UpdatedAt]) VALUES (2, 1, 1, 1, N'Technical', CAST(N'2026-09-16T19:14:12.0059879' AS DateTime2), 45, N'Video', N'https://meet.example.com/interview-ananya-r1', NULL, N'Cancelled', NULL, 2, CAST(N'2026-09-13T19:14:12.0627475' AS DateTime2), CAST(N'2026-09-13T19:19:42.6260260' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Interviews] OFF
GO
SET IDENTITY_INSERT [dbo].[JobFamilies] ON 
GO
INSERT [dbo].[JobFamilies] ([Id], [Name], [Description], [IsActive]) VALUES (1, N'Software Engineering', N'Backend, frontend, and full-stack roles', 1)
GO
INSERT [dbo].[JobFamilies] ([Id], [Name], [Description], [IsActive]) VALUES (2, N'Product Design', N'UX/UI and product design roles', 1)
GO
SET IDENTITY_INSERT [dbo].[JobFamilies] OFF
GO
SET IDENTITY_INSERT [dbo].[JobRequisitionAudit] ON 
GO
INSERT [dbo].[JobRequisitionAudit] ([Id], [JobRequisitionId], [Action], [FromStatus], [ToStatus], [PerformedBy], [Notes], [PerformedAt]) VALUES (1, 1, N'Created', NULL, N'Draft', 3, NULL, CAST(N'2026-09-13T19:14:12.0228591' AS DateTime2))
GO
INSERT [dbo].[JobRequisitionAudit] ([Id], [JobRequisitionId], [Action], [FromStatus], [ToStatus], [PerformedBy], [Notes], [PerformedAt]) VALUES (2, 1, N'PendingApproval', N'Draft', N'PendingApproval', 3, NULL, CAST(N'2026-09-13T19:14:12.0278588' AS DateTime2))
GO
INSERT [dbo].[JobRequisitionAudit] ([Id], [JobRequisitionId], [Action], [FromStatus], [ToStatus], [PerformedBy], [Notes], [PerformedAt]) VALUES (3, 1, N'Approved', N'PendingApproval', N'Approved', 1, N'Budget confirmed.', CAST(N'2026-09-13T19:14:12.0288549' AS DateTime2))
GO
INSERT [dbo].[JobRequisitionAudit] ([Id], [JobRequisitionId], [Action], [FromStatus], [ToStatus], [PerformedBy], [Notes], [PerformedAt]) VALUES (4, 2, N'Created', NULL, N'Draft', 3, NULL, CAST(N'2026-09-13T19:14:12.0290360' AS DateTime2))
GO
INSERT [dbo].[JobRequisitionAudit] ([Id], [JobRequisitionId], [Action], [FromStatus], [ToStatus], [PerformedBy], [Notes], [PerformedAt]) VALUES (5, 3, N'Created', NULL, N'Draft', 3, NULL, CAST(N'2026-09-13T19:14:12.0300423' AS DateTime2))
GO
INSERT [dbo].[JobRequisitionAudit] ([Id], [JobRequisitionId], [Action], [FromStatus], [ToStatus], [PerformedBy], [Notes], [PerformedAt]) VALUES (6, 3, N'PendingApproval', N'Draft', N'PendingApproval', 3, NULL, CAST(N'2026-09-13T19:14:12.0308470' AS DateTime2))
GO
INSERT [dbo].[JobRequisitionAudit] ([Id], [JobRequisitionId], [Action], [FromStatus], [ToStatus], [PerformedBy], [Notes], [PerformedAt]) VALUES (7, 3, N'Rejected', N'PendingApproval', N'Rejected', 1, N'No budget headcount left this quarter.', CAST(N'2026-09-13T19:14:12.0309555' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[JobRequisitionAudit] OFF
GO
SET IDENTITY_INSERT [dbo].[JobRequisitions] ON 
GO
INSERT [dbo].[JobRequisitions] ([Id], [Title], [Department], [Location], [EmploymentType], [Vacancies], [Priority], [RequisitionType], [TargetJoiningDate], [BudgetReference], [JustificationNotes], [RequiredSkills], [HiringManagerId], [RecruiterId], [JobId], [Status], [ApprovedBy], [ApprovedAt], [RejectionReason], [CreatedBy], [CreatedAt], [UpdatedAt]) VALUES (1, N'Senior Backend Engineer', N'Engineering', N'Bengaluru, India', N'Full-time', 2, N'High', N'New', NULL, N'ENG-FY26-014', N'Team is understaffed for the platform rewrite.', N'C#, .NET, SQL Server, Azure', 3, 2, 1, N'Approved', 1, CAST(N'2026-09-13T19:14:12.0278588' AS DateTime2), NULL, 3, CAST(N'2026-09-13T19:14:12.0228591' AS DateTime2), CAST(N'2026-09-13T19:14:12.0339603' AS DateTime2))
GO
INSERT [dbo].[JobRequisitions] ([Id], [Title], [Department], [Location], [EmploymentType], [Vacancies], [Priority], [RequisitionType], [TargetJoiningDate], [BudgetReference], [JustificationNotes], [RequiredSkills], [HiringManagerId], [RecruiterId], [JobId], [Status], [ApprovedBy], [ApprovedAt], [RejectionReason], [CreatedBy], [CreatedAt], [UpdatedAt]) VALUES (2, N'Product Designer', N'Design', N'Remote', N'Full-time', 1, N'Medium', N'New', NULL, N'DES-FY26-003', N'New design system initiative.', N'Figma, Design Systems', 3, 2, NULL, N'Draft', NULL, NULL, NULL, 3, CAST(N'2026-09-13T19:14:12.0290360' AS DateTime2), NULL)
GO
INSERT [dbo].[JobRequisitions] ([Id], [Title], [Department], [Location], [EmploymentType], [Vacancies], [Priority], [RequisitionType], [TargetJoiningDate], [BudgetReference], [JustificationNotes], [RequiredSkills], [HiringManagerId], [RecruiterId], [JobId], [Status], [ApprovedBy], [ApprovedAt], [RejectionReason], [CreatedBy], [CreatedAt], [UpdatedAt]) VALUES (3, N'Data Analyst', N'Analytics', N'Pune, India', N'Full-time', 1, N'Low', N'New', NULL, NULL, N'Nice-to-have for Q3 reporting.', N'SQL, Power BI', 3, 2, NULL, N'Rejected', NULL, NULL, N'No budget headcount left this quarter.', 3, CAST(N'2026-09-13T19:14:12.0290360' AS DateTime2), CAST(N'2026-09-13T19:14:12.0309555' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[JobRequisitions] OFF
GO
SET IDENTITY_INSERT [dbo].[Jobs] ON 
GO
INSERT [dbo].[Jobs] ([Id], [Title], [Description], [Requirements], [Responsibilities], [Location], [EmploymentType], [SalaryMin], [SalaryMax], [ExperienceYearsMin], [ExperienceYearsMax], [Skills], [Department], [Status], [PostedDate], [ClosedDate], [PostedBy], [CreatedAt], [UpdatedAt], [MustHaveSkills], [NiceToHaveSkills], [EducationRequirement], [WorkMode], [BenefitsText], [LegalText], [JobRequisitionId]) VALUES (1, N'Senior Backend Engineer', N'Own the design and delivery of core platform services.', N'5+ years building production APIs; strong SQL skills.', N'Design services, review code, mentor engineers.', N'Bengaluru, India', N'Full-time', CAST(1800000.00 AS Decimal(18, 2)), CAST(2800000.00 AS Decimal(18, 2)), 5, 10, N'C#, .NET, SQL Server, Azure', N'Engineering', N'Open', CAST(N'2026-09-13T19:14:12.0059879' AS DateTime2), NULL, 2, CAST(N'2026-09-13T19:14:12.0319613' AS DateTime2), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Jobs] ([Id], [Title], [Description], [Requirements], [Responsibilities], [Location], [EmploymentType], [SalaryMin], [SalaryMax], [ExperienceYearsMin], [ExperienceYearsMax], [Skills], [Department], [Status], [PostedDate], [ClosedDate], [PostedBy], [CreatedAt], [UpdatedAt], [MustHaveSkills], [NiceToHaveSkills], [EducationRequirement], [WorkMode], [BenefitsText], [LegalText], [JobRequisitionId]) VALUES (2, N'Product Designer', N'Shape end-to-end product experiences for the recruiter workspace.', N'Portfolio showing systems-level design thinking.', N'Own design system, run user research, prototype flows.', N'Remote', N'Full-time', CAST(1200000.00 AS Decimal(18, 2)), CAST(2000000.00 AS Decimal(18, 2)), 3, 8, N'Figma, Design Systems, User Research', N'Design', N'Open', CAST(N'2026-09-13T19:14:12.0059879' AS DateTime2), NULL, 2, CAST(N'2026-09-13T19:14:12.0349594' AS DateTime2), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[Jobs] ([Id], [Title], [Description], [Requirements], [Responsibilities], [Location], [EmploymentType], [SalaryMin], [SalaryMax], [ExperienceYearsMin], [ExperienceYearsMax], [Skills], [Department], [Status], [PostedDate], [ClosedDate], [PostedBy], [CreatedAt], [UpdatedAt], [MustHaveSkills], [NiceToHaveSkills], [EducationRequirement], [WorkMode], [BenefitsText], [LegalText], [JobRequisitionId]) VALUES (3, N'QA Engineer', N'Contract QA role for a 6-month release stabilization effort.', N'Experience with automated test suites.', N'Write and maintain automated tests, triage defects.', N'Pune, India', N'Contract', CAST(800000.00 AS Decimal(18, 2)), CAST(1200000.00 AS Decimal(18, 2)), 2, 5, N'Selenium, Playwright, SQL', N'Engineering', N'Closed', CAST(N'2026-08-14T19:14:12.0059879' AS DateTime2), CAST(N'2026-09-13T19:14:12.0059879' AS DateTime2), 2, CAST(N'2026-09-13T19:14:12.0349594' AS DateTime2), CAST(N'2026-09-13T19:14:12.0389555' AS DateTime2), NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Jobs] OFF
GO
SET IDENTITY_INSERT [dbo].[Lookups] ON 
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (1, N'Gender', N'Male', 1, 1)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (2, N'Gender', N'Female', 1, 2)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (3, N'Gender', N'Other', 1, 3)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (4, N'Gender', N'Prefer not to say', 1, 4)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (5, N'MaritalStatus', N'Single', 1, 1)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (6, N'MaritalStatus', N'Married', 1, 2)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (7, N'MaritalStatus', N'Divorced', 1, 3)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (8, N'MaritalStatus', N'Widowed', 1, 4)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (9, N'EmploymentType', N'Full-time', 1, 1)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (10, N'EmploymentType', N'Part-time', 1, 2)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (11, N'EmploymentType', N'Contract', 1, 3)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (12, N'EmploymentType', N'Internship', 1, 4)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (13, N'EmploymentType', N'Freelance', 1, 5)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (14, N'Source', N'Job Portal', 1, 1)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (15, N'Source', N'Referral', 1, 2)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (16, N'Source', N'Social Media', 1, 3)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (17, N'Source', N'Company Website', 1, 4)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (18, N'Source', N'Recruiter', 1, 5)
GO
INSERT [dbo].[Lookups] ([Id], [Category], [Value], [IsActive], [SortOrder]) VALUES (19, N'Source', N'Walk-in', 1, 6)
GO
SET IDENTITY_INSERT [dbo].[Lookups] OFF
GO
SET IDENTITY_INSERT [dbo].[OfficeLocations] ON 
GO
INSERT [dbo].[OfficeLocations] ([Id], [Name], [City], [Country], [IsActive]) VALUES (1, N'Bengaluru HQ', N'Bengaluru', N'India', 1)
GO
INSERT [dbo].[OfficeLocations] ([Id], [Name], [City], [Country], [IsActive]) VALUES (2, N'Remote', NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[OfficeLocations] OFF
GO
SET IDENTITY_INSERT [dbo].[Referrals] ON 
GO
INSERT [dbo].[Referrals] ([Id], [ReferrerUserId], [JobId], [CandidateId], [ReferralCode], [Status], [BonusAmount], [BonusStatus], [CreatedAt]) VALUES (1, 1, 1, NULL, N'84D441E0', N'LinkGenerated', NULL, N'NotEligible', CAST(N'2026-09-13T19:20:29.8381085' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Referrals] OFF
GO
SET IDENTITY_INSERT [dbo].[States] ON 
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (1, 1, N'Andhra Pradesh')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (2, 1, N'Arunachal Pradesh')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (3, 1, N'Assam')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (4, 1, N'Bihar')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (29, 1, N'Chandigarh')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (5, 1, N'Chhattisgarh')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (30, 1, N'Dadra and Nagar Haveli and Daman and Diu')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (32, 1, N'Delhi')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (6, 1, N'Goa')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (7, 1, N'Gujarat')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (8, 1, N'Haryana')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (9, 1, N'Himachal Pradesh')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (35, 1, N'Jammu and Kashmir')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (10, 1, N'Jharkhand')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (11, 1, N'Karnataka')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (12, 1, N'Kerala')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (34, 1, N'Ladakh')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (31, 1, N'Lakshadweep')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (13, 1, N'Madhya Pradesh')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (14, 1, N'Maharashtra')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (15, 1, N'Manipur')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (16, 1, N'Meghalaya')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (17, 1, N'Mizoram')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (18, 1, N'Nagaland')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (19, 1, N'Odisha')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (33, 1, N'Puducherry')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (20, 1, N'Punjab')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (21, 1, N'Rajasthan')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (22, 1, N'Sikkim')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (23, 1, N'Tamil Nadu')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (24, 1, N'Telangana')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (25, 1, N'Tripura')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (26, 1, N'Uttar Pradesh')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (27, 1, N'Uttarakhand')
GO
INSERT [dbo].[States] ([Id], [CountryId], [Name]) VALUES (28, 1, N'West Bengal')
GO
SET IDENTITY_INSERT [dbo].[States] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [IsActive], [CreatedAt], [UpdatedAt], [AgencyId]) VALUES (1, N'Portal Admin', N'admin@recruitmentportal.com', N'100000.c91iNcmTAytngrBnRXO7mQ==.fFi0DhFA2mVGhL+9ypCqFS7v7rW+t0hNe/RTE/g2zr4=', N'Admin', 1, CAST(N'2026-09-13T19:14:12.0059879' AS DateTime2), NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [IsActive], [CreatedAt], [UpdatedAt], [AgencyId]) VALUES (2, N'Riya Sharma', N'recruiter@recruitmentportal.com', N'100000.j98UB5HcsfWUCxdyuJUfsg==.qoqzuljyDX3d0htvNnH/lXVlwRh7e0ty+xHhozv/294=', N'Recruiter', 1, CAST(N'2026-09-13T19:14:12.0149697' AS DateTime2), NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [IsActive], [CreatedAt], [UpdatedAt], [AgencyId]) VALUES (3, N'Vikram Mehta', N'hiringmanager@recruitmentportal.com', N'100000.MkyyEf/bnEUHlgTkcJMPAw==.+v3BV3VslCwnOWdZQbiUWCLd/HBq6EBSQpQYqUCTDxE=', N'HiringManager', 1, CAST(N'2026-09-13T19:14:12.0149697' AS DateTime2), NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [IsActive], [CreatedAt], [UpdatedAt], [AgencyId]) VALUES (4, N'Ananya Rao', N'candidate1@example.com', N'100000.6wfmRuUqI5WKmCNZ8qUzaw==.DpQb52iy/H684UthMMd5pzLWN+eTtlbo4aZFFsjPF5A=', N'Candidate', 1, CAST(N'2026-09-13T19:14:12.0149697' AS DateTime2), NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [IsActive], [CreatedAt], [UpdatedAt], [AgencyId]) VALUES (5, N'Karan Patel', N'candidate2@example.com', N'100000.9EdQ2Sn+bCsj/yd4Fyt/Dw==.+tOEPKwBe7jXamabihoEG+ppDwnMi10rg5HgqgVsDZg=', N'Candidate', 1, CAST(N'2026-09-13T19:14:12.0149697' AS DateTime2), NULL, NULL)
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [IsActive], [CreatedAt], [UpdatedAt], [AgencyId]) VALUES (6, N'Sara Khan', N'candidate3@example.com', N'100000.7RBO79tq7eEO9/OLtsa67Q==.DDU/bUajg+u8HxNBAK5DgDkXkXz+4/1F5OZkNCQqB3s=', N'Candidate', 1, CAST(N'2026-09-13T19:14:12.0149697' AS DateTime2), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Candidat__E3168DDCC5C37487]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[CandidateTags] ADD UNIQUE NONCLUSTERED 
(
	[CandidateId] ASC,
	[Tag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Competen__737584F6B0F3F3A0]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[Competencies] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Countrie__737584F661AF227E]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[Countries] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Departme__737584F6C6F3F768]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[Departments] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__EmailTem__A25C5AA7D25B6331]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[EmailTemplates] ADD UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Intervie__0555E5F290E0611D]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[InterviewFeedback] ADD UNIQUE NONCLUSTERED 
(
	[InterviewId] ASC,
	[InterviewerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Intervie__0555E5F2B1680EA3]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[InterviewPanelists] ADD UNIQUE NONCLUSTERED 
(
	[InterviewId] ASC,
	[InterviewerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Intervie__98B2E4C3FFE86380]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[InterviewPanelMasterMembers] ADD UNIQUE NONCLUSTERED 
(
	[PanelId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__JobFamil__737584F6D7781E54]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[JobFamilies] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Referral__7E067812B647D725]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[Referrals] ADD UNIQUE NONCLUSTERED 
(
	[ReferralCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__SkillsMa__737584F62F68D29B]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[SkillsMaster] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__States__77E638D143657921]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[States] ADD UNIQUE NONCLUSTERED 
(
	[CountryId] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__TalentPo__565B91006CF357CF]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[TalentPoolMembers] ADD UNIQUE NONCLUSTERED 
(
	[TalentPoolId] ASC,
	[CandidateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D10534B5AC60A0]    Script Date: 14-09-2026 1.50.03 AM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Agencies] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Agencies] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AgencySubmissions] ADD  DEFAULT (sysutcdatetime()) FOR [SubmittedAt]
GO
ALTER TABLE [dbo].[AgencySubmissions] ADD  DEFAULT ((0)) FOR [WasDuplicate]
GO
ALTER TABLE [dbo].[ApprovalMatrices] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[AssessmentInvitations] ADD  DEFAULT (sysutcdatetime()) FOR [InvitedAt]
GO
ALTER TABLE [dbo].[AssessmentInvitations] ADD  DEFAULT ('Invited') FOR [Status]
GO
ALTER TABLE [dbo].[AssessmentTemplates] ADD  DEFAULT ('Technical') FOR [AssessmentType]
GO
ALTER TABLE [dbo].[AssessmentTemplates] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[AssessmentTemplates] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[CandidateNotes] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Candidates] ADD  DEFAULT ('Applied') FOR [Status]
GO
ALTER TABLE [dbo].[Candidates] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[CandidateStageHistory] ADD  DEFAULT (sysutcdatetime()) FOR [ChangedAt]
GO
ALTER TABLE [dbo].[CandidateTags] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Competencies] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Departments] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[EmailLog] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[EmailLog] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EmailTemplates] ADD  DEFAULT ('General') FOR [Category]
GO
ALTER TABLE [dbo].[EmailTemplates] ADD  DEFAULT ((0)) FOR [IsSystem]
GO
ALTER TABLE [dbo].[EmailTemplates] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[EmailTemplates] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[HireEvents] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[HireEvents] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[InterviewFeedback] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[InterviewPanelists] ADD  DEFAULT ((0)) FOR [IsLead]
GO
ALTER TABLE [dbo].[InterviewPanelsMaster] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InterviewPanelsMaster] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Interviews] ADD  DEFAULT ((1)) FOR [RoundNumber]
GO
ALTER TABLE [dbo].[Interviews] ADD  DEFAULT ('Scheduled') FOR [Status]
GO
ALTER TABLE [dbo].[Interviews] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[JobFamilies] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[JobPostingChannels] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[JobPostingChannels] ADD  DEFAULT (sysutcdatetime()) FOR [PostedAt]
GO
ALTER TABLE [dbo].[JobRequisitionAudit] ADD  DEFAULT (sysutcdatetime()) FOR [PerformedAt]
GO
ALTER TABLE [dbo].[JobRequisitions] ADD  DEFAULT ((1)) FOR [Vacancies]
GO
ALTER TABLE [dbo].[JobRequisitions] ADD  DEFAULT ('Medium') FOR [Priority]
GO
ALTER TABLE [dbo].[JobRequisitions] ADD  DEFAULT ('New') FOR [RequisitionType]
GO
ALTER TABLE [dbo].[JobRequisitions] ADD  DEFAULT ('Draft') FOR [Status]
GO
ALTER TABLE [dbo].[JobRequisitions] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Jobs] ADD  DEFAULT ('Open') FOR [Status]
GO
ALTER TABLE [dbo].[Jobs] ADD  DEFAULT (sysutcdatetime()) FOR [PostedDate]
GO
ALTER TABLE [dbo].[Jobs] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Lookups] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Lookups] ADD  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[OfferAudit] ADD  DEFAULT (sysutcdatetime()) FOR [PerformedAt]
GO
ALTER TABLE [dbo].[Offers] ADD  DEFAULT ('Draft') FOR [Status]
GO
ALTER TABLE [dbo].[Offers] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[OfficeLocations] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[PreJoiningChecklists] ADD  DEFAULT ('NotStarted') FOR [BgvStatus]
GO
ALTER TABLE [dbo].[PreJoiningChecklists] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[PreJoiningTasks] ADD  DEFAULT ((0)) FOR [IsCompleted]
GO
ALTER TABLE [dbo].[PreJoiningTasks] ADD  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Referrals] ADD  DEFAULT ('LinkGenerated') FOR [Status]
GO
ALTER TABLE [dbo].[Referrals] ADD  DEFAULT ('NotEligible') FOR [BonusStatus]
GO
ALTER TABLE [dbo].[Referrals] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[SalaryBands] ADD  DEFAULT ('INR') FOR [Currency]
GO
ALTER TABLE [dbo].[SalaryBands] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SavedSearches] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ScreeningForms] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ScreeningForms] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ScreeningQuestions] ADD  DEFAULT ('Text') FOR [QuestionType]
GO
ALTER TABLE [dbo].[ScreeningQuestions] ADD  DEFAULT ((0)) FOR [IsKnockout]
GO
ALTER TABLE [dbo].[ScreeningQuestions] ADD  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[ScreeningResponses] ADD  DEFAULT (sysutcdatetime()) FOR [SubmittedAt]
GO
ALTER TABLE [dbo].[ScreeningResponses] ADD  DEFAULT ((0)) FOR [KnockoutFailed]
GO
ALTER TABLE [dbo].[SkillsMaster] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SmtpSettings] ADD  DEFAULT ('Custom') FOR [Provider]
GO
ALTER TABLE [dbo].[SmtpSettings] ADD  DEFAULT ((587)) FOR [Port]
GO
ALTER TABLE [dbo].[SmtpSettings] ADD  DEFAULT ('Auto') FOR [SecureSocketMode]
GO
ALTER TABLE [dbo].[SmtpSettings] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[SmtpSettings] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[TalentPoolMembers] ADD  DEFAULT (sysutcdatetime()) FOR [AddedAt]
GO
ALTER TABLE [dbo].[TalentPools] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ('Candidate') FOR [Role]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AgencySubmissions]  WITH CHECK ADD FOREIGN KEY([AgencyId])
REFERENCES [dbo].[Agencies] ([Id])
GO
ALTER TABLE [dbo].[AgencySubmissions]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[AgencySubmissions]  WITH CHECK ADD FOREIGN KEY([DuplicateOfCandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[AgencySubmissions]  WITH CHECK ADD FOREIGN KEY([JobId])
REFERENCES [dbo].[Jobs] ([Id])
GO
ALTER TABLE [dbo].[AgencySubmissions]  WITH CHECK ADD FOREIGN KEY([SubmittedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[AssessmentInvitations]  WITH CHECK ADD FOREIGN KEY([AssessmentTemplateId])
REFERENCES [dbo].[AssessmentTemplates] ([Id])
GO
ALTER TABLE [dbo].[AssessmentInvitations]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[AssessmentInvitations]  WITH CHECK ADD FOREIGN KEY([InvitedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[AssessmentTemplates]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CandidateNotes]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[CandidateNotes]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Candidates]  WITH CHECK ADD FOREIGN KEY([JobId])
REFERENCES [dbo].[Jobs] ([Id])
GO
ALTER TABLE [dbo].[Candidates]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CandidateStageHistory]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[CandidateStageHistory]  WITH CHECK ADD FOREIGN KEY([ChangedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CandidateTags]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[CandidateTags]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[EmailLog]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[EmailLog]  WITH CHECK ADD FOREIGN KEY([SentBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[EmailTemplates]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[HireEvents]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[HireEvents]  WITH CHECK ADD FOREIGN KEY([OfferId])
REFERENCES [dbo].[Offers] ([Id])
GO
ALTER TABLE [dbo].[InterviewFeedback]  WITH CHECK ADD FOREIGN KEY([InterviewId])
REFERENCES [dbo].[Interviews] ([Id])
GO
ALTER TABLE [dbo].[InterviewFeedback]  WITH CHECK ADD FOREIGN KEY([InterviewerId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[InterviewPanelists]  WITH CHECK ADD FOREIGN KEY([InterviewId])
REFERENCES [dbo].[Interviews] ([Id])
GO
ALTER TABLE [dbo].[InterviewPanelists]  WITH CHECK ADD FOREIGN KEY([InterviewerId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[InterviewPanelMasterMembers]  WITH CHECK ADD FOREIGN KEY([PanelId])
REFERENCES [dbo].[InterviewPanelsMaster] ([Id])
GO
ALTER TABLE [dbo].[InterviewPanelMasterMembers]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[InterviewPanelsMaster]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Interviews]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[Interviews]  WITH CHECK ADD FOREIGN KEY([JobId])
REFERENCES [dbo].[Jobs] ([Id])
GO
ALTER TABLE [dbo].[Interviews]  WITH CHECK ADD FOREIGN KEY([ScheduledBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[JobPostingChannels]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[JobPostingChannels]  WITH CHECK ADD FOREIGN KEY([JobId])
REFERENCES [dbo].[Jobs] ([Id])
GO
ALTER TABLE [dbo].[JobRequisitionAudit]  WITH CHECK ADD FOREIGN KEY([JobRequisitionId])
REFERENCES [dbo].[JobRequisitions] ([Id])
GO
ALTER TABLE [dbo].[JobRequisitionAudit]  WITH CHECK ADD FOREIGN KEY([PerformedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[JobRequisitions]  WITH CHECK ADD FOREIGN KEY([ApprovedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[JobRequisitions]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[JobRequisitions]  WITH CHECK ADD FOREIGN KEY([HiringManagerId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[JobRequisitions]  WITH CHECK ADD FOREIGN KEY([JobId])
REFERENCES [dbo].[Jobs] ([Id])
GO
ALTER TABLE [dbo].[JobRequisitions]  WITH CHECK ADD FOREIGN KEY([RecruiterId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Jobs]  WITH CHECK ADD FOREIGN KEY([JobRequisitionId])
REFERENCES [dbo].[JobRequisitions] ([Id])
GO
ALTER TABLE [dbo].[Jobs]  WITH CHECK ADD FOREIGN KEY([PostedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[OfferAudit]  WITH CHECK ADD FOREIGN KEY([OfferId])
REFERENCES [dbo].[Offers] ([Id])
GO
ALTER TABLE [dbo].[OfferAudit]  WITH CHECK ADD FOREIGN KEY([PerformedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Offers]  WITH CHECK ADD FOREIGN KEY([ApprovedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Offers]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[Offers]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Offers]  WITH CHECK ADD FOREIGN KEY([JobId])
REFERENCES [dbo].[Jobs] ([Id])
GO
ALTER TABLE [dbo].[PreJoiningChecklists]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[PreJoiningChecklists]  WITH CHECK ADD FOREIGN KEY([OfferId])
REFERENCES [dbo].[Offers] ([Id])
GO
ALTER TABLE [dbo].[PreJoiningTasks]  WITH CHECK ADD FOREIGN KEY([ChecklistId])
REFERENCES [dbo].[PreJoiningChecklists] ([Id])
GO
ALTER TABLE [dbo].[Referrals]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[Referrals]  WITH CHECK ADD FOREIGN KEY([JobId])
REFERENCES [dbo].[Jobs] ([Id])
GO
ALTER TABLE [dbo].[Referrals]  WITH CHECK ADD FOREIGN KEY([ReferrerUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[SalaryBands]  WITH CHECK ADD FOREIGN KEY([JobFamilyId])
REFERENCES [dbo].[JobFamilies] ([Id])
GO
ALTER TABLE [dbo].[SavedSearches]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ScreeningAnswers]  WITH CHECK ADD FOREIGN KEY([QuestionId])
REFERENCES [dbo].[ScreeningQuestions] ([Id])
GO
ALTER TABLE [dbo].[ScreeningAnswers]  WITH CHECK ADD FOREIGN KEY([ScreeningResponseId])
REFERENCES [dbo].[ScreeningResponses] ([Id])
GO
ALTER TABLE [dbo].[ScreeningForms]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ScreeningForms]  WITH CHECK ADD FOREIGN KEY([JobId])
REFERENCES [dbo].[Jobs] ([Id])
GO
ALTER TABLE [dbo].[ScreeningQuestions]  WITH CHECK ADD FOREIGN KEY([ScreeningFormId])
REFERENCES [dbo].[ScreeningForms] ([Id])
GO
ALTER TABLE [dbo].[ScreeningResponses]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[ScreeningResponses]  WITH CHECK ADD FOREIGN KEY([EvaluatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ScreeningResponses]  WITH CHECK ADD FOREIGN KEY([ScreeningFormId])
REFERENCES [dbo].[ScreeningForms] ([Id])
GO
ALTER TABLE [dbo].[SmtpSettings]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[States]  WITH CHECK ADD FOREIGN KEY([CountryId])
REFERENCES [dbo].[Countries] ([Id])
GO
ALTER TABLE [dbo].[TalentPoolMembers]  WITH CHECK ADD FOREIGN KEY([AddedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[TalentPoolMembers]  WITH CHECK ADD FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidates] ([Id])
GO
ALTER TABLE [dbo].[TalentPoolMembers]  WITH CHECK ADD FOREIGN KEY([TalentPoolId])
REFERENCES [dbo].[TalentPools] ([Id])
GO
ALTER TABLE [dbo].[TalentPools]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([AgencyId])
REFERENCES [dbo].[Agencies] ([Id])
GO
/****** Object:  StoredProcedure [dbo].[sp_Agency_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: Agencies
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Agency_Create]
    @Name NVARCHAR(150), @ContactEmail NVARCHAR(256) = NULL, @ContactPhone NVARCHAR(30) = NULL
AS BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Agencies (Name, ContactEmail, ContactPhone) VALUES (@Name, @ContactEmail, @ContactPhone);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Agency_CreateUser]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Creates the Agency's portal user account (Role = 'Agency', linked to the agency).
CREATE   PROCEDURE [dbo].[sp_Agency_CreateUser]
    @AgencyId INT, @FullName NVARCHAR(256), @Email NVARCHAR(256), @PasswordHash NVARCHAR(MAX)
AS BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Users (FullName, Email, PasswordHash, Role, AgencyId)
    VALUES (@FullName, @Email, @PasswordHash, 'Agency', @AgencyId);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Agency_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Agency_GetAll]
AS BEGIN
    SET NOCOUNT ON;
    SELECT Id, Name, ContactEmail, ContactPhone, IsActive, CreatedAt FROM dbo.Agencies WHERE IsActive = 1 ORDER BY Name;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Agency_GetPerformance]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Agency_GetPerformance]
AS BEGIN
    SET NOCOUNT ON;
    SELECT a.Id, a.Name,
           COUNT(s.Id) AS TotalSubmissions,
           SUM(CASE WHEN s.WasDuplicate = 1 THEN 1 ELSE 0 END) AS DuplicateSubmissions,
           SUM(CASE WHEN c.Status = 'Hired' THEN 1 ELSE 0 END) AS Hires
    FROM dbo.Agencies a
    LEFT JOIN dbo.AgencySubmissions s ON s.AgencyId = a.Id
    LEFT JOIN dbo.Candidates c ON c.Id = s.CandidateId
    GROUP BY a.Id, a.Name
    ORDER BY a.Name;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AgencySubmission_CheckDuplicate]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: Agency submissions (duplicate-protected)
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_AgencySubmission_CheckDuplicate]
    @Email NVARCHAR(256)
AS BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 Id, FirstName, LastName, Source FROM dbo.Candidates WHERE Email = @Email ORDER BY CreatedAt;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AgencySubmission_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Links an already-created Candidate (see CandidatesController) to the submitting agency.
-- If @DuplicateOfCandidateId is supplied, the submission is recorded as a duplicate for
-- agency-performance reporting and no new candidate ownership is granted.
CREATE   PROCEDURE [dbo].[sp_AgencySubmission_Create]
    @AgencyId INT, @JobId INT = NULL, @CandidateId INT = NULL, @SubmittedBy INT,
    @WasDuplicate BIT = 0, @DuplicateOfCandidateId INT = NULL
AS BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.AgencySubmissions (AgencyId, JobId, CandidateId, SubmittedBy, WasDuplicate, DuplicateOfCandidateId)
    VALUES (@AgencyId, @JobId, @CandidateId, @SubmittedBy, @WasDuplicate, @DuplicateOfCandidateId);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AgencySubmission_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AgencySubmission_GetAll]
AS BEGIN
    SET NOCOUNT ON;
    SELECT s.Id, s.AgencyId, a.Name AS AgencyName, s.JobId, j.Title AS JobTitle, s.CandidateId,
           c.FirstName, c.LastName, c.Status AS CandidateStatus, s.SubmittedBy, s.SubmittedAt, s.WasDuplicate
    FROM dbo.AgencySubmissions s
    INNER JOIN dbo.Agencies a ON a.Id = s.AgencyId
    LEFT JOIN dbo.Jobs j ON j.Id = s.JobId
    LEFT JOIN dbo.Candidates c ON c.Id = s.CandidateId
    ORDER BY s.SubmittedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AgencySubmission_GetByAgencyId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AgencySubmission_GetByAgencyId]
    @AgencyId INT
AS BEGIN
    SET NOCOUNT ON;
    SELECT s.Id, s.AgencyId, s.JobId, j.Title AS JobTitle, s.CandidateId,
           c.FirstName, c.LastName, c.Status AS CandidateStatus, s.SubmittedBy, s.SubmittedAt, s.WasDuplicate
    FROM dbo.AgencySubmissions s
    LEFT JOIN dbo.Jobs j ON j.Id = s.JobId
    LEFT JOIN dbo.Candidates c ON c.Id = s.CandidateId
    WHERE s.AgencyId = @AgencyId
    ORDER BY s.SubmittedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Analytics_InterviewTurnaround]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Average hours between scheduling and the panel submitting feedback, for completed interviews.
CREATE   PROCEDURE [dbo].[sp_Analytics_InterviewTurnaround]
AS BEGIN
    SET NOCOUNT ON;
    SELECT i.Id AS InterviewId, i.ScheduledAt, MAX(f.SubmittedAt) AS LastFeedbackAt,
           DATEDIFF(HOUR, i.ScheduledAt, MAX(f.SubmittedAt)) AS HoursToFeedback
    FROM dbo.Interviews i
    INNER JOIN dbo.InterviewFeedback f ON f.InterviewId = i.Id
    WHERE i.ScheduledAt IS NOT NULL AND f.SubmittedAt IS NOT NULL
    GROUP BY i.Id, i.ScheduledAt
    ORDER BY i.ScheduledAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Analytics_OfferStats]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Offer acceptance rate among offers that received a response.
CREATE   PROCEDURE [dbo].[sp_Analytics_OfferStats]
AS BEGIN
    SET NOCOUNT ON;
    SELECT Status, COUNT(*) AS Count FROM dbo.Offers GROUP BY Status;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Analytics_RecruiterProductivity]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Per-recruiter productivity: requisitions, stage moves made, interviews scheduled, offers created.
CREATE   PROCEDURE [dbo].[sp_Analytics_RecruiterProductivity]
AS BEGIN
    SET NOCOUNT ON;
    SELECT u.Id AS UserId, u.FullName,
        (SELECT COUNT(*) FROM dbo.JobRequisitions r WHERE r.CreatedBy = u.Id) AS RequisitionsCreated,
        (SELECT COUNT(*) FROM dbo.CandidateStageHistory h WHERE h.ChangedBy = u.Id) AS StageMovesMade,
        (SELECT COUNT(*) FROM dbo.Interviews i WHERE i.ScheduledBy = u.Id) AS InterviewsScheduled,
        (SELECT COUNT(*) FROM dbo.Offers o WHERE o.CreatedBy = u.Id) AS OffersCreated
    FROM dbo.Users u
    WHERE u.Role IN ('Recruiter', 'Admin', 'HiringManager')
    ORDER BY u.FullName;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Analytics_SourceEffectiveness]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Applications, shortlist rate, and hire rate per source.
CREATE   PROCEDURE [dbo].[sp_Analytics_SourceEffectiveness]
AS BEGIN
    SET NOCOUNT ON;
    SELECT
        COALESCE(Source, 'Unknown') AS Source,
        COUNT(*) AS TotalApplications,
        SUM(CASE WHEN Status IN ('Shortlisted','Interview','Assessment','Final Evaluation','Offer','Offer Accepted','Pre-Joining','Hired') THEN 1 ELSE 0 END) AS Shortlisted,
        SUM(CASE WHEN Status = 'Hired' THEN 1 ELSE 0 END) AS Hired
    FROM dbo.Candidates
    GROUP BY Source
    ORDER BY TotalApplications DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Analytics_StageFunnel]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Cumulative funnel: how many candidates ever REACHED each stage (monotonically non-increasing).
CREATE   PROCEDURE [dbo].[sp_Analytics_StageFunnel]
AS BEGIN
    SET NOCOUNT ON;
    SELECT ToStatus AS Stage, COUNT(DISTINCT CandidateId) AS CandidateCount
    FROM dbo.CandidateStageHistory
    GROUP BY ToStatus
    ORDER BY CandidateCount DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Analytics_TimeToFill]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Average days from a job's posting date to its first "Hired" candidate.
CREATE   PROCEDURE [dbo].[sp_Analytics_TimeToFill]
AS BEGIN
    SET NOCOUNT ON;
    SELECT j.Id AS JobId, j.Title, j.PostedDate, MIN(h.ChangedAt) AS FirstHiredAt,
           DATEDIFF(DAY, j.PostedDate, MIN(h.ChangedAt)) AS DaysToFill
    FROM dbo.Jobs j
    INNER JOIN dbo.Candidates c ON c.JobId = j.Id
    INNER JOIN dbo.CandidateStageHistory h ON h.CandidateId = c.Id AND h.ToStatus = 'Hired'
    GROUP BY j.Id, j.Title, j.PostedDate
    ORDER BY j.PostedDate DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Analytics_TimeToHire]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Average days from a candidate's application to reaching "Hired".
CREATE   PROCEDURE [dbo].[sp_Analytics_TimeToHire]
AS BEGIN
    SET NOCOUNT ON;
    SELECT c.Id AS CandidateId, c.FirstName, c.LastName, c.CreatedAt AS AppliedAt, MIN(h.ChangedAt) AS HiredAt,
           DATEDIFF(DAY, c.CreatedAt, MIN(h.ChangedAt)) AS DaysToHire
    FROM dbo.Candidates c
    INNER JOIN dbo.CandidateStageHistory h ON h.CandidateId = c.Id AND h.ToStatus = 'Hired'
    GROUP BY c.Id, c.FirstName, c.LastName, c.CreatedAt
    ORDER BY c.CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ApprovalMatrix_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_ApprovalMatrix_Create]
    @Name NVARCHAR(150), @Description NVARCHAR(500) = NULL, @MinAmount DECIMAL(18,2) = NULL, @MaxAmount DECIMAL(18,2) = NULL, @RequiredApproverRole NVARCHAR(50)
AS BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.ApprovalMatrices (Name, Description, MinAmount, MaxAmount, RequiredApproverRole) VALUES (@Name, @Description, @MinAmount, @MaxAmount, @RequiredApproverRole);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ApprovalMatrix_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_ApprovalMatrix_Delete] @Id INT AS BEGIN SET NOCOUNT ON; UPDATE dbo.ApprovalMatrices SET IsActive = 0 WHERE Id = @Id; SELECT @@ROWCOUNT; END

GO
/****** Object:  StoredProcedure [dbo].[sp_ApprovalMatrix_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_ApprovalMatrix_GetAll] AS BEGIN SET NOCOUNT ON; SELECT Id, Name, Description, MinAmount, MaxAmount, RequiredApproverRole, IsActive FROM dbo.ApprovalMatrices WHERE IsActive = 1 ORDER BY MinAmount; END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentInvitation_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AssessmentInvitation_Create]
    @CandidateId INT,
    @AssessmentTemplateId INT,
    @InvitedBy INT = NULL,
    @Deadline DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.AssessmentInvitations (CandidateId, AssessmentTemplateId, InvitedBy, Deadline, Status)
    VALUES (@CandidateId, @AssessmentTemplateId, @InvitedBy, @Deadline, 'Invited');

    DECLARE @NewId INT = CAST(SCOPE_IDENTITY() AS INT);

    EXEC dbo.sp_Candidate_ChangeStage @CandidateId = @CandidateId, @NewStatus = 'Assessment', @ChangedBy = @InvitedBy, @Reason = 'Assessment invitation sent';

    SELECT @NewId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentInvitation_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AssessmentInvitation_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT i.Id, i.CandidateId, i.AssessmentTemplateId, t.Title AS AssessmentTitle, t.AssessmentType,
           i.InvitedBy, i.InvitedAt, i.Deadline, i.Status, i.Score, i.PassFail, i.CompletedAt, i.Notes
    FROM dbo.AssessmentInvitations i
    INNER JOIN dbo.AssessmentTemplates t ON t.Id = i.AssessmentTemplateId
    ORDER BY i.InvitedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentInvitation_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AssessmentInvitation_GetByCandidateId]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT i.Id, i.CandidateId, i.AssessmentTemplateId, t.Title AS AssessmentTitle, t.AssessmentType,
           i.InvitedBy, i.InvitedAt, i.Deadline, i.Status, i.Score, i.PassFail, i.CompletedAt, i.Notes
    FROM dbo.AssessmentInvitations i
    INNER JOIN dbo.AssessmentTemplates t ON t.Id = i.AssessmentTemplateId
    WHERE i.CandidateId = @CandidateId
    ORDER BY i.InvitedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentInvitation_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AssessmentInvitation_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT i.Id, i.CandidateId, i.AssessmentTemplateId, t.Title AS AssessmentTitle, t.AssessmentType,
           i.InvitedBy, i.InvitedAt, i.Deadline, i.Status, i.Score, i.PassFail, i.CompletedAt, i.Notes
    FROM dbo.AssessmentInvitations i
    INNER JOIN dbo.AssessmentTemplates t ON t.Id = i.AssessmentTemplateId
    WHERE i.Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentInvitation_RecordResult]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Records a result, computes pass/fail against the template's passing score, and
-- automates the resulting pipeline stage move (spec: "pass/fail rules and stage automation").
CREATE   PROCEDURE [dbo].[sp_AssessmentInvitation_RecordResult]
    @Id INT,
    @Score INT,
    @Notes NVARCHAR(1000) = NULL,
    @PerformedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CandidateId INT, @PassingScore INT;
    SELECT @CandidateId = i.CandidateId, @PassingScore = t.PassingScore
    FROM dbo.AssessmentInvitations i
    INNER JOIN dbo.AssessmentTemplates t ON t.Id = i.AssessmentTemplateId
    WHERE i.Id = @Id;

    DECLARE @PassFail NVARCHAR(10) = CASE
        WHEN @PassingScore IS NULL THEN NULL
        WHEN @Score >= @PassingScore THEN 'Pass'
        ELSE 'Fail'
    END;

    UPDATE dbo.AssessmentInvitations
    SET Score = @Score, PassFail = @PassFail, Status = 'Completed', CompletedAt = SYSUTCDATETIME(),
        Notes = COALESCE(@Notes, Notes)
    WHERE Id = @Id;

    IF @PassFail = 'Pass'
        EXEC dbo.sp_Candidate_ChangeStage @CandidateId = @CandidateId, @NewStatus = 'Final Evaluation', @ChangedBy = @PerformedBy, @Reason = 'Passed assessment';
    ELSE IF @PassFail = 'Fail'
        EXEC dbo.sp_Candidate_ChangeStage @CandidateId = @CandidateId, @NewStatus = 'Rejected', @ChangedBy = @PerformedBy, @Reason = 'Did not meet assessment passing score';

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentInvitation_UpdateStatus]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AssessmentInvitation_UpdateStatus]
    @Id INT,
    @Status NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.AssessmentInvitations SET Status = @Status WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentTemplate_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_AssessmentTemplate_Create]
    @Title NVARCHAR(256),
    @AssessmentType NVARCHAR(50),
    @Description NVARCHAR(1000) = NULL,
    @VendorName NVARCHAR(150) = NULL,
    @ExternalLink NVARCHAR(500) = NULL,
    @PassingScore INT = NULL,
    @DurationMinutes INT = NULL,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.AssessmentTemplates
        (Title, AssessmentType, Description, VendorName, ExternalLink, PassingScore, DurationMinutes, CreatedBy)
    VALUES
        (@Title, @AssessmentType, @Description, @VendorName, @ExternalLink, @PassingScore, @DurationMinutes, @CreatedBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentTemplate_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AssessmentTemplate_Delete]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.AssessmentTemplates SET IsActive = 0 WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentTemplate_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AssessmentTemplate_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Title, AssessmentType, Description, VendorName, ExternalLink, PassingScore, DurationMinutes, IsActive, CreatedBy, CreatedAt
    FROM dbo.AssessmentTemplates
    WHERE IsActive = 1
    ORDER BY Title;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AssessmentTemplate_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_AssessmentTemplate_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Title, AssessmentType, Description, VendorName, ExternalLink, PassingScore, DurationMinutes, IsActive, CreatedBy, CreatedAt
    FROM dbo.AssessmentTemplates WHERE Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_ChangeStage]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: recruitment pipeline / stage changes
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Candidate_ChangeStage]
    @CandidateId INT,
    @NewStatus NVARCHAR(50),
    @ChangedBy INT = NULL,
    @Reason NVARCHAR(200) = NULL,
    @Notes NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentStatus NVARCHAR(50);
    SELECT @CurrentStatus = Status FROM dbo.Candidates WHERE Id = @CandidateId;

    IF @CurrentStatus IS NULL
    BEGIN
        -- Candidate does not exist; report zero rows affected.
        SELECT CAST(0 AS INT) AS RowsAffected;
        RETURN;
    END

    UPDATE dbo.Candidates
    SET Status = @NewStatus, UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @CandidateId;

    INSERT INTO dbo.CandidateStageHistory (CandidateId, FromStatus, ToStatus, ChangedBy, Reason, Notes)
    VALUES (@CandidateId, @CurrentStatus, @NewStatus, @ChangedBy, @Reason, @Notes);

    SELECT CAST(1 AS INT) AS RowsAffected;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Candidate_Create]
    @UserId INT = NULL,
    @JobId INT = NULL,
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100) = NULL,
    @LastName NVARCHAR(100),
    @Email NVARCHAR(256),
    @Phone NVARCHAR(20) = NULL,
    @AlternatePhone NVARCHAR(20) = NULL,
    @DateOfBirth DATETIME2 = NULL,
    @Gender NVARCHAR(50) = NULL,
    @MaritalStatus NVARCHAR(50) = NULL,
    @Nationality NVARCHAR(100) = NULL,
    @Address NVARCHAR(500) = NULL,
    @City NVARCHAR(100) = NULL,
    @State NVARCHAR(100) = NULL,
    @Country NVARCHAR(100) = NULL,
    @PostalCode NVARCHAR(20) = NULL,
    @PositionApplied NVARCHAR(150) = NULL,
    @EmploymentType NVARCHAR(100) = NULL,
    @TotalExperience DECIMAL(5,2) = NULL,
    @CurrentCompany NVARCHAR(150) = NULL,
    @CurrentCtc DECIMAL(18,2) = NULL,
    @ExpectedCtc DECIMAL(18,2) = NULL,
    @NoticePeriodDays INT = NULL,
    @PreferredLocation NVARCHAR(150) = NULL,
    @WillingToRelocate BIT = NULL,
    @AvailableFrom DATETIME2 = NULL,
    @HighestQualification NVARCHAR(150) = NULL,
    @Skills NVARCHAR(MAX) = NULL,
    @LinkedInUrl NVARCHAR(300) = NULL,
    @PortfolioUrl NVARCHAR(300) = NULL,
    @GitHubUrl NVARCHAR(300) = NULL,
    @ResumeUrl NVARCHAR(300) = NULL,
    @CoverLetter NVARCHAR(MAX) = NULL,
    @ReferenceName NVARCHAR(150) = NULL,
    @ReferenceContact NVARCHAR(150) = NULL,
    @Source NVARCHAR(100) = NULL,
    @Status NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Candidates
        (UserId, JobId, FirstName, MiddleName, LastName, Email, Phone, AlternatePhone, DateOfBirth,
         Gender, MaritalStatus, Nationality, Address, City, State, Country, PostalCode,
         PositionApplied, EmploymentType, TotalExperience, CurrentCompany, CurrentCtc, ExpectedCtc,
         NoticePeriodDays, PreferredLocation, WillingToRelocate, AvailableFrom, HighestQualification,
         Skills, LinkedInUrl, PortfolioUrl, GitHubUrl, ResumeUrl, CoverLetter, ReferenceName,
         ReferenceContact, Source, Status)
    VALUES
        (@UserId, @JobId, @FirstName, @MiddleName, @LastName, @Email, @Phone, @AlternatePhone, @DateOfBirth,
         @Gender, @MaritalStatus, @Nationality, @Address, @City, @State, @Country, @PostalCode,
         @PositionApplied, @EmploymentType, @TotalExperience, @CurrentCompany, @CurrentCtc, @ExpectedCtc,
         @NoticePeriodDays, @PreferredLocation, @WillingToRelocate, @AvailableFrom, @HighestQualification,
         @Skills, @LinkedInUrl, @PortfolioUrl, @GitHubUrl, @ResumeUrl, @CoverLetter, @ReferenceName,
         @ReferenceContact, @Source, @Status);

    DECLARE @NewId INT = CAST(SCOPE_IDENTITY() AS INT);

    INSERT INTO dbo.CandidateStageHistory (CandidateId, FromStatus, ToStatus, ChangedBy, Reason, Notes)
    VALUES (@NewId, NULL, @Status, @UserId, 'Application submitted', NULL);

    SELECT @NewId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Candidate_Delete]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Candidates WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: dbo.Candidates
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Candidate_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, UserId, JobId, FirstName, MiddleName, LastName, Email, Phone, AlternatePhone, DateOfBirth,
           Gender, MaritalStatus, Nationality, Address, City, State, Country, PostalCode,
           PositionApplied, EmploymentType, TotalExperience, CurrentCompany, CurrentCtc, ExpectedCtc,
           NoticePeriodDays, PreferredLocation, WillingToRelocate, AvailableFrom, HighestQualification,
           Skills, LinkedInUrl, PortfolioUrl, GitHubUrl, ResumeUrl, ResumeFileName, CoverLetter, ReferenceName,
           ReferenceContact, Source, Status, CreatedAt, UpdatedAt
    FROM dbo.Candidates
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Candidate_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, UserId, JobId, FirstName, MiddleName, LastName, Email, Phone, AlternatePhone, DateOfBirth,
           Gender, MaritalStatus, Nationality, Address, City, State, Country, PostalCode,
           PositionApplied, EmploymentType, TotalExperience, CurrentCompany, CurrentCtc, ExpectedCtc,
           NoticePeriodDays, PreferredLocation, WillingToRelocate, AvailableFrom, HighestQualification,
           Skills, LinkedInUrl, PortfolioUrl, GitHubUrl, ResumeUrl, ResumeFileName, CoverLetter, ReferenceName,
           ReferenceContact, Source, Status, CreatedAt, UpdatedAt
    FROM dbo.Candidates
    WHERE Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_GetByUserId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Candidate_GetByUserId]
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, UserId, JobId, FirstName, MiddleName, LastName, Email, Phone, AlternatePhone, DateOfBirth,
           Gender, MaritalStatus, Nationality, Address, City, State, Country, PostalCode,
           PositionApplied, EmploymentType, TotalExperience, CurrentCompany, CurrentCtc, ExpectedCtc,
           NoticePeriodDays, PreferredLocation, WillingToRelocate, AvailableFrom, HighestQualification,
           Skills, LinkedInUrl, PortfolioUrl, GitHubUrl, ResumeUrl, ResumeFileName, CoverLetter, ReferenceName,
           ReferenceContact, Source, Status, CreatedAt, UpdatedAt
    FROM dbo.Candidates
    WHERE UserId = @UserId
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_GetStageHistory]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Candidate_GetStageHistory]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, FromStatus, ToStatus, ChangedBy, Reason, Notes, ChangedAt
    FROM dbo.CandidateStageHistory
    WHERE CandidateId = @CandidateId
    ORDER BY ChangedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_Search]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: candidate search + saved searches
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Candidate_Search]
    @Keyword NVARCHAR(200) = NULL,
    @MinExperience DECIMAL(5,2) = NULL,
    @MaxExperience DECIMAL(5,2) = NULL,
    @Location NVARCHAR(150) = NULL,
    @Status NVARCHAR(50) = NULL,
    @Source NVARCHAR(100) = NULL,
    @Tag NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Like NVARCHAR(202) = N'%' + @Keyword + N'%';

    SELECT DISTINCT c.Id, c.UserId, c.JobId, c.FirstName, c.MiddleName, c.LastName, c.Email, c.Phone,
           c.PositionApplied, c.EmploymentType, c.TotalExperience, c.CurrentCompany, c.ExpectedCtc,
           c.PreferredLocation, c.City, c.Country, c.Skills, c.Source, c.Status, c.CreatedAt
    FROM dbo.Candidates c
    LEFT JOIN dbo.CandidateTags t ON t.CandidateId = c.Id
    WHERE (@Keyword IS NULL OR
           c.FirstName LIKE @Like OR c.LastName LIKE @Like OR c.Email LIKE @Like OR
           c.Skills LIKE @Like OR c.PositionApplied LIKE @Like OR c.CurrentCompany LIKE @Like)
      AND (@MinExperience IS NULL OR c.TotalExperience >= @MinExperience)
      AND (@MaxExperience IS NULL OR c.TotalExperience <= @MaxExperience)
      AND (@Location IS NULL OR c.PreferredLocation LIKE '%' + @Location + '%' OR c.City LIKE '%' + @Location + '%')
      AND (@Status IS NULL OR c.Status = @Status)
      AND (@Source IS NULL OR c.Source = @Source)
      AND (@Tag IS NULL OR t.Tag = @Tag)
    ORDER BY c.CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_Update]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Candidate_Update]
    @Id INT,
    @JobId INT = NULL,
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100) = NULL,
    @LastName NVARCHAR(100),
    @Email NVARCHAR(256),
    @Phone NVARCHAR(20) = NULL,
    @AlternatePhone NVARCHAR(20) = NULL,
    @DateOfBirth DATETIME2 = NULL,
    @Gender NVARCHAR(50) = NULL,
    @MaritalStatus NVARCHAR(50) = NULL,
    @Nationality NVARCHAR(100) = NULL,
    @Address NVARCHAR(500) = NULL,
    @City NVARCHAR(100) = NULL,
    @State NVARCHAR(100) = NULL,
    @Country NVARCHAR(100) = NULL,
    @PostalCode NVARCHAR(20) = NULL,
    @PositionApplied NVARCHAR(150) = NULL,
    @EmploymentType NVARCHAR(100) = NULL,
    @TotalExperience DECIMAL(5,2) = NULL,
    @CurrentCompany NVARCHAR(150) = NULL,
    @CurrentCtc DECIMAL(18,2) = NULL,
    @ExpectedCtc DECIMAL(18,2) = NULL,
    @NoticePeriodDays INT = NULL,
    @PreferredLocation NVARCHAR(150) = NULL,
    @WillingToRelocate BIT = NULL,
    @AvailableFrom DATETIME2 = NULL,
    @HighestQualification NVARCHAR(150) = NULL,
    @Skills NVARCHAR(MAX) = NULL,
    @LinkedInUrl NVARCHAR(300) = NULL,
    @PortfolioUrl NVARCHAR(300) = NULL,
    @GitHubUrl NVARCHAR(300) = NULL,
    @ResumeUrl NVARCHAR(300) = NULL,
    @CoverLetter NVARCHAR(MAX) = NULL,
    @ReferenceName NVARCHAR(150) = NULL,
    @ReferenceContact NVARCHAR(150) = NULL,
    @Source NVARCHAR(100) = NULL,
    @Status NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Candidates SET
        JobId = @JobId, FirstName = @FirstName, MiddleName = @MiddleName, LastName = @LastName, Email = @Email,
        Phone = @Phone, AlternatePhone = @AlternatePhone, DateOfBirth = @DateOfBirth,
        Gender = @Gender, MaritalStatus = @MaritalStatus, Nationality = @Nationality,
        Address = @Address, City = @City, State = @State, Country = @Country, PostalCode = @PostalCode,
        PositionApplied = @PositionApplied, EmploymentType = @EmploymentType,
        TotalExperience = @TotalExperience, CurrentCompany = @CurrentCompany, CurrentCtc = @CurrentCtc,
        ExpectedCtc = @ExpectedCtc, NoticePeriodDays = @NoticePeriodDays,
        PreferredLocation = @PreferredLocation, WillingToRelocate = @WillingToRelocate,
        AvailableFrom = @AvailableFrom, HighestQualification = @HighestQualification, Skills = @Skills,
        LinkedInUrl = @LinkedInUrl, PortfolioUrl = @PortfolioUrl, GitHubUrl = @GitHubUrl,
        ResumeUrl = @ResumeUrl, CoverLetter = @CoverLetter, ReferenceName = @ReferenceName,
        ReferenceContact = @ReferenceContact, Source = @Source, Status = @Status,
        UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Candidate_UpdateResume]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Candidate_UpdateResume]
    @Id INT,
    @ResumeUrl NVARCHAR(300),
    @ResumeFileName NVARCHAR(300)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Candidates SET
        ResumeUrl = @ResumeUrl,
        ResumeFileName = @ResumeFileName,
        UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CandidateNote_Add]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: notes, tags
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_CandidateNote_Add]
    @CandidateId INT,
    @Note NVARCHAR(MAX),
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.CandidateNotes (CandidateId, Note, CreatedBy) VALUES (@CandidateId, @Note, @CreatedBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CandidateNote_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_CandidateNote_GetByCandidateId]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT n.Id, n.CandidateId, n.Note, n.CreatedBy, u.FullName AS CreatedByName, n.CreatedAt
    FROM dbo.CandidateNotes n
    LEFT JOIN dbo.Users u ON u.Id = n.CreatedBy
    WHERE n.CandidateId = @CandidateId
    ORDER BY n.CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CandidateTag_Add]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_CandidateTag_Add]
    @CandidateId INT,
    @Tag NVARCHAR(50),
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.CandidateTags WHERE CandidateId = @CandidateId AND Tag = @Tag)
        INSERT INTO dbo.CandidateTags (CandidateId, Tag, CreatedBy) VALUES (@CandidateId, @Tag, @CreatedBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CandidateTag_GetAllDistinct]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_CandidateTag_GetAllDistinct]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT Tag FROM dbo.CandidateTags ORDER BY Tag;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CandidateTag_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_CandidateTag_GetByCandidateId]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, Tag, CreatedBy, CreatedAt
    FROM dbo.CandidateTags
    WHERE CandidateId = @CandidateId
    ORDER BY Tag;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_CandidateTag_Remove]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_CandidateTag_Remove]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.CandidateTags WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Competency_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_Competency_Create] @Name NVARCHAR(150), @Description NVARCHAR(500) = NULL AS BEGIN SET NOCOUNT ON; INSERT INTO dbo.Competencies (Name, Description) VALUES (@Name, @Description); SELECT CAST(SCOPE_IDENTITY() AS INT); END

GO
/****** Object:  StoredProcedure [dbo].[sp_Competency_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_Competency_Delete] @Id INT AS BEGIN SET NOCOUNT ON; UPDATE dbo.Competencies SET IsActive = 0 WHERE Id = @Id; SELECT @@ROWCOUNT; END

GO
/****** Object:  StoredProcedure [dbo].[sp_Competency_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Competency_GetAll] AS BEGIN SET NOCOUNT ON; SELECT Id, Name, Description, IsActive FROM dbo.Competencies WHERE IsActive = 1 ORDER BY Name; END

GO
/****** Object:  StoredProcedure [dbo].[sp_Department_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_Department_Create] @Name NVARCHAR(150) AS BEGIN SET NOCOUNT ON; INSERT INTO dbo.Departments (Name) VALUES (@Name); SELECT CAST(SCOPE_IDENTITY() AS INT); END

GO
/****** Object:  StoredProcedure [dbo].[sp_Department_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_Department_Delete] @Id INT AS BEGIN SET NOCOUNT ON; UPDATE dbo.Departments SET IsActive = 0 WHERE Id = @Id; SELECT @@ROWCOUNT; END

GO
/****** Object:  StoredProcedure [dbo].[sp_Department_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- Generic CRUD stored procedures for the simple master-data tables.
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Department_GetAll] AS BEGIN SET NOCOUNT ON; SELECT Id, Name, IsActive FROM dbo.Departments WHERE IsActive = 1 ORDER BY Name; END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailLog_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: email log (communication audit trail)
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_EmailLog_Create]
    @ToEmail NVARCHAR(256),
    @Subject NVARCHAR(300),
    @Body NVARCHAR(MAX),
    @TemplateCode NVARCHAR(80) = NULL,
    @CandidateId INT = NULL,
    @SentBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.EmailLog (ToEmail, Subject, Body, TemplateCode, CandidateId, Status, SentBy)
    VALUES (@ToEmail, @Subject, @Body, @TemplateCode, @CandidateId, 'Pending', @SentBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailLog_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_EmailLog_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 500 Id, ToEmail, Subject, TemplateCode, CandidateId, Status, ErrorMessage, SentBy, CreatedAt, SentAt
    FROM dbo.EmailLog
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailLog_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_EmailLog_GetByCandidateId]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, ToEmail, Subject, Body, TemplateCode, CandidateId, Status, ErrorMessage, SentBy, CreatedAt, SentAt
    FROM dbo.EmailLog
    WHERE CandidateId = @CandidateId
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailLog_MarkResult]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_EmailLog_MarkResult]
    @Id INT,
    @Status NVARCHAR(20),
    @ErrorMessage NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.EmailLog
    SET Status = @Status, ErrorMessage = @ErrorMessage, SentAt = CASE WHEN @Status = 'Sent' THEN SYSUTCDATETIME() ELSE SentAt END
    WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailTemplate_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_EmailTemplate_Create]
    @Code NVARCHAR(80),
    @Name NVARCHAR(150),
    @Subject NVARCHAR(300),
    @BodyHtml NVARCHAR(MAX),
    @Category NVARCHAR(50),
    @IsSystem BIT = 0,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.EmailTemplates (Code, Name, Subject, BodyHtml, Category, IsSystem, CreatedBy)
    VALUES (@Code, @Name, @Subject, @BodyHtml, @Category, @IsSystem, @CreatedBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailTemplate_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_EmailTemplate_Delete]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.EmailTemplates WHERE Id = @Id AND IsSystem = 0;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailTemplate_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: email templates
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_EmailTemplate_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Code, Name, Subject, BodyHtml, Category, IsSystem, IsActive, CreatedBy, CreatedAt, UpdatedAt
    FROM dbo.EmailTemplates
    ORDER BY Category, Name;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailTemplate_GetByCode]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_EmailTemplate_GetByCode]
    @Code NVARCHAR(80)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Code, Name, Subject, BodyHtml, Category, IsSystem, IsActive, CreatedBy, CreatedAt, UpdatedAt
    FROM dbo.EmailTemplates
    WHERE Code = @Code;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailTemplate_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_EmailTemplate_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Code, Name, Subject, BodyHtml, Category, IsSystem, IsActive, CreatedBy, CreatedAt, UpdatedAt
    FROM dbo.EmailTemplates
    WHERE Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmailTemplate_Update]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_EmailTemplate_Update]
    @Id INT,
    @Name NVARCHAR(150),
    @Subject NVARCHAR(300),
    @BodyHtml NVARCHAR(MAX),
    @Category NVARCHAR(50),
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.EmailTemplates
    SET Name = @Name, Subject = @Subject, BodyHtml = @BodyHtml, Category = @Category, IsActive = @IsActive, UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_HireEvent_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_HireEvent_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT h.Id, h.CandidateId, c.FirstName, c.LastName, h.OfferId, h.Payload, h.Status, h.CreatedAt, h.SentAt
    FROM dbo.HireEvents h
    INNER JOIN dbo.Candidates c ON c.Id = h.CandidateId
    ORDER BY h.CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_HireEvent_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: Hire events (structured handoff to HR/ERP)
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_HireEvent_GetByCandidateId]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, OfferId, Payload, Status, CreatedAt, SentAt
    FROM dbo.HireEvents
    WHERE CandidateId = @CandidateId
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_HireEvent_MarkSent]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_HireEvent_MarkSent]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.HireEvents SET Status = 'Sent', SentAt = SYSUTCDATETIME() WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Interview_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Interview_Create]
    @CandidateId INT,
    @JobId INT = NULL,
    @RoundNumber INT,
    @InterviewType NVARCHAR(100) = NULL,
    @ScheduledAt DATETIME2 = NULL,
    @DurationMinutes INT = NULL,
    @Mode NVARCHAR(50) = NULL,
    @MeetingLink NVARCHAR(500) = NULL,
    @Location NVARCHAR(300) = NULL,
    @ScheduledBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Interviews
        (CandidateId, JobId, RoundNumber, InterviewType, ScheduledAt, DurationMinutes,
         Mode, MeetingLink, Location, Status, ScheduledBy)
    VALUES
        (@CandidateId, @JobId, @RoundNumber, @InterviewType, @ScheduledAt, @DurationMinutes,
         @Mode, @MeetingLink, @Location, 'Scheduled', @ScheduledBy);

    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Interview_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: dbo.Interviews
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Interview_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, JobId, RoundNumber, InterviewType, ScheduledAt, DurationMinutes,
           Mode, MeetingLink, Location, Status, CancellationReason, ScheduledBy, CreatedAt, UpdatedAt
    FROM dbo.Interviews
    ORDER BY ScheduledAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Interview_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Interview_GetByCandidateId]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, JobId, RoundNumber, InterviewType, ScheduledAt, DurationMinutes,
           Mode, MeetingLink, Location, Status, CancellationReason, ScheduledBy, CreatedAt, UpdatedAt
    FROM dbo.Interviews
    WHERE CandidateId = @CandidateId
    ORDER BY ScheduledAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Interview_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Interview_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, JobId, RoundNumber, InterviewType, ScheduledAt, DurationMinutes,
           Mode, MeetingLink, Location, Status, CancellationReason, ScheduledBy, CreatedAt, UpdatedAt
    FROM dbo.Interviews
    WHERE Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Interview_GetPanelists]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Interview_GetPanelists]
    @InterviewId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.Id, p.InterviewId, p.InterviewerId, p.IsLead, u.FullName AS InterviewerName, u.Email AS InterviewerEmail
    FROM dbo.InterviewPanelists p
    INNER JOIN dbo.Users u ON u.Id = p.InterviewerId
    WHERE p.InterviewId = @InterviewId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Interview_GetUpcoming]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Interview_GetUpcoming]
    @FromDate DATETIME2
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, JobId, RoundNumber, InterviewType, ScheduledAt, DurationMinutes,
           Mode, MeetingLink, Location, Status, CancellationReason, ScheduledBy, CreatedAt, UpdatedAt
    FROM dbo.Interviews
    WHERE ScheduledAt >= @FromDate AND Status = 'Scheduled'
    ORDER BY ScheduledAt ASC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Interview_Reschedule]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Interview_Reschedule]
    @Id INT,
    @ScheduledAt DATETIME2,
    @DurationMinutes INT = NULL,
    @Mode NVARCHAR(50) = NULL,
    @MeetingLink NVARCHAR(500) = NULL,
    @Location NVARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Interviews SET
        ScheduledAt = @ScheduledAt, DurationMinutes = @DurationMinutes, Mode = @Mode,
        MeetingLink = @MeetingLink, Location = @Location, Status = 'Scheduled',
        UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Interview_UpdateStatus]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Interview_UpdateStatus]
    @Id INT,
    @Status NVARCHAR(50),
    @CancellationReason NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Interviews SET
        Status = @Status,
        CancellationReason = CASE WHEN @Status = 'Cancelled' THEN @CancellationReason ELSE CancellationReason END,
        UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewFeedback_GetByInterviewId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_InterviewFeedback_GetByInterviewId]
    @InterviewId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT f.Id, f.InterviewId, f.InterviewerId, u.FullName AS InterviewerName, f.Rating, f.Recommendation,
           f.Strengths, f.Concerns, f.Comments, f.SubmittedAt, f.CreatedAt
    FROM dbo.InterviewFeedback f
    INNER JOIN dbo.Users u ON u.Id = f.InterviewerId
    WHERE f.InterviewId = @InterviewId
    ORDER BY f.SubmittedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewFeedback_Submit]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Upsert: an interviewer can only submit one scorecard per interview.
CREATE   PROCEDURE [dbo].[sp_InterviewFeedback_Submit]
    @InterviewId INT,
    @InterviewerId INT,
    @Rating INT = NULL,
    @Recommendation NVARCHAR(50) = NULL,
    @Strengths NVARCHAR(MAX) = NULL,
    @Concerns NVARCHAR(MAX) = NULL,
    @Comments NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.InterviewFeedback WHERE InterviewId = @InterviewId AND InterviewerId = @InterviewerId)
    BEGIN
        UPDATE dbo.InterviewFeedback SET
            Rating = @Rating, Recommendation = @Recommendation, Strengths = @Strengths,
            Concerns = @Concerns, Comments = @Comments, SubmittedAt = SYSUTCDATETIME()
        WHERE InterviewId = @InterviewId AND InterviewerId = @InterviewerId;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.InterviewFeedback
            (InterviewId, InterviewerId, Rating, Recommendation, Strengths, Concerns, Comments, SubmittedAt)
        VALUES
            (@InterviewId, @InterviewerId, @Rating, @Recommendation, @Strengths, @Concerns, @Comments, SYSUTCDATETIME());
    END

    SELECT Id FROM dbo.InterviewFeedback WHERE InterviewId = @InterviewId AND InterviewerId = @InterviewerId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewPanelist_Add]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_InterviewPanelist_Add]
    @InterviewId INT,
    @InterviewerId INT,
    @IsLead BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.InterviewPanelists WHERE InterviewId = @InterviewId AND InterviewerId = @InterviewerId)
    BEGIN
        INSERT INTO dbo.InterviewPanelists (InterviewId, InterviewerId, IsLead)
        VALUES (@InterviewId, @InterviewerId, @IsLead);
    END

    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewPanelist_Remove]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_InterviewPanelist_Remove]
    @InterviewId INT,
    @InterviewerId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.InterviewPanelists WHERE InterviewId = @InterviewId AND InterviewerId = @InterviewerId;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewPanelMaster_AddMember]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_InterviewPanelMaster_AddMember]
    @PanelId INT, @UserId INT
AS BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.InterviewPanelMasterMembers WHERE PanelId = @PanelId AND UserId = @UserId)
        INSERT INTO dbo.InterviewPanelMasterMembers (PanelId, UserId) VALUES (@PanelId, @UserId);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewPanelMaster_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- Reusable interview panels
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_InterviewPanelMaster_Create]
    @Name NVARCHAR(150), @Description NVARCHAR(500) = NULL, @CreatedBy INT = NULL
AS BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.InterviewPanelsMaster (Name, Description, CreatedBy) VALUES (@Name, @Description, @CreatedBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewPanelMaster_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_InterviewPanelMaster_Delete] @Id INT AS BEGIN SET NOCOUNT ON; UPDATE dbo.InterviewPanelsMaster SET IsActive = 0 WHERE Id = @Id; SELECT @@ROWCOUNT; END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewPanelMaster_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_InterviewPanelMaster_GetAll]
AS BEGIN
    SET NOCOUNT ON;
    SELECT p.Id, p.Name, p.Description, p.IsActive, p.CreatedBy, p.CreatedAt,
           (SELECT COUNT(*) FROM dbo.InterviewPanelMasterMembers m WHERE m.PanelId = p.Id) AS MemberCount
    FROM dbo.InterviewPanelsMaster p
    WHERE p.IsActive = 1
    ORDER BY p.Name;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewPanelMaster_GetMembers]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_InterviewPanelMaster_GetMembers]
    @PanelId INT
AS BEGIN
    SET NOCOUNT ON;
    SELECT m.Id, m.PanelId, m.UserId, u.FullName, u.Email
    FROM dbo.InterviewPanelMasterMembers m
    INNER JOIN dbo.Users u ON u.Id = m.UserId
    WHERE m.PanelId = @PanelId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InterviewPanelMaster_RemoveMember]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_InterviewPanelMaster_RemoveMember]
    @PanelId INT, @UserId INT
AS BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.InterviewPanelMasterMembers WHERE PanelId = @PanelId AND UserId = @UserId;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Job_Create]
    @Title NVARCHAR(256),
    @Description NVARCHAR(MAX),
    @Requirements NVARCHAR(MAX) = NULL,
    @Responsibilities NVARCHAR(MAX) = NULL,
    @Location NVARCHAR(256),
    @EmploymentType NVARCHAR(100) = NULL,
    @SalaryMin DECIMAL(18,2) = NULL,
    @SalaryMax DECIMAL(18,2) = NULL,
    @ExperienceYearsMin INT = NULL,
    @ExperienceYearsMax INT = NULL,
    @Skills NVARCHAR(MAX) = NULL,
    @Department NVARCHAR(256),
    @Status NVARCHAR(50),
    @PostedDate DATETIME2,
    @PostedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Jobs
        (Title, Description, Requirements, Responsibilities, Location, EmploymentType,
         SalaryMin, SalaryMax, ExperienceYearsMin, ExperienceYearsMax, Skills, Department,
         Status, PostedDate, PostedBy)
    VALUES
        (@Title, @Description, @Requirements, @Responsibilities, @Location, @EmploymentType,
         @SalaryMin, @SalaryMax, @ExperienceYearsMin, @ExperienceYearsMax, @Skills, @Department,
         @Status, @PostedDate, @PostedBy);

    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_CreateFull]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: extended Job create/update (superset of sp_Job_Create/Update)
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Job_CreateFull]
    @Title NVARCHAR(256),
    @Description NVARCHAR(MAX),
    @Requirements NVARCHAR(MAX) = NULL,
    @Responsibilities NVARCHAR(MAX) = NULL,
    @Location NVARCHAR(256),
    @EmploymentType NVARCHAR(100) = NULL,
    @SalaryMin DECIMAL(18,2) = NULL,
    @SalaryMax DECIMAL(18,2) = NULL,
    @ExperienceYearsMin INT = NULL,
    @ExperienceYearsMax INT = NULL,
    @Skills NVARCHAR(MAX) = NULL,
    @Department NVARCHAR(256),
    @Status NVARCHAR(50),
    @PostedDate DATETIME2,
    @PostedBy INT = NULL,
    @MustHaveSkills NVARCHAR(MAX) = NULL,
    @NiceToHaveSkills NVARCHAR(MAX) = NULL,
    @EducationRequirement NVARCHAR(300) = NULL,
    @WorkMode NVARCHAR(30) = NULL,
    @BenefitsText NVARCHAR(MAX) = NULL,
    @LegalText NVARCHAR(MAX) = NULL,
    @JobRequisitionId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Jobs
        (Title, Description, Requirements, Responsibilities, Location, EmploymentType,
         SalaryMin, SalaryMax, ExperienceYearsMin, ExperienceYearsMax, Skills, Department,
         Status, PostedDate, PostedBy, MustHaveSkills, NiceToHaveSkills, EducationRequirement,
         WorkMode, BenefitsText, LegalText, JobRequisitionId)
    VALUES
        (@Title, @Description, @Requirements, @Responsibilities, @Location, @EmploymentType,
         @SalaryMin, @SalaryMax, @ExperienceYearsMin, @ExperienceYearsMax, @Skills, @Department,
         @Status, @PostedDate, @PostedBy, @MustHaveSkills, @NiceToHaveSkills, @EducationRequirement,
         @WorkMode, @BenefitsText, @LegalText, @JobRequisitionId);

    DECLARE @NewId INT = CAST(SCOPE_IDENTITY() AS INT);

    IF @JobRequisitionId IS NOT NULL
        EXEC dbo.sp_JobRequisition_LinkJob @Id = @JobRequisitionId, @JobId = @NewId;

    SELECT @NewId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Job_Delete]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Jobs WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: dbo.Jobs
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Job_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Title, Description, Requirements, Responsibilities, Location, EmploymentType,
           SalaryMin, SalaryMax, ExperienceYearsMin, ExperienceYearsMax, Skills, Department,
           Status, PostedDate, ClosedDate, PostedBy, CreatedAt, UpdatedAt
    FROM dbo.Jobs
    ORDER BY PostedDate DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_GetAllFull]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Job_GetAllFull]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Title, Description, Requirements, Responsibilities, Location, EmploymentType,
           SalaryMin, SalaryMax, ExperienceYearsMin, ExperienceYearsMax, Skills, Department,
           Status, PostedDate, ClosedDate, PostedBy, CreatedAt, UpdatedAt,
           MustHaveSkills, NiceToHaveSkills, EducationRequirement, WorkMode, BenefitsText, LegalText, JobRequisitionId
    FROM dbo.Jobs
    ORDER BY PostedDate DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Job_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Title, Description, Requirements, Responsibilities, Location, EmploymentType,
           SalaryMin, SalaryMax, ExperienceYearsMin, ExperienceYearsMax, Skills, Department,
           Status, PostedDate, ClosedDate, PostedBy, CreatedAt, UpdatedAt
    FROM dbo.Jobs
    WHERE Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_GetByIdFull]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Job_GetByIdFull]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Title, Description, Requirements, Responsibilities, Location, EmploymentType,
           SalaryMin, SalaryMax, ExperienceYearsMin, ExperienceYearsMax, Skills, Department,
           Status, PostedDate, ClosedDate, PostedBy, CreatedAt, UpdatedAt,
           MustHaveSkills, NiceToHaveSkills, EducationRequirement, WorkMode, BenefitsText, LegalText, JobRequisitionId
    FROM dbo.Jobs
    WHERE Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_GetOpen]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Job_GetOpen]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Title, Description, Requirements, Responsibilities, Location, EmploymentType,
           SalaryMin, SalaryMax, ExperienceYearsMin, ExperienceYearsMax, Skills, Department,
           Status, PostedDate, ClosedDate, PostedBy, CreatedAt, UpdatedAt
    FROM dbo.Jobs
    WHERE Status = 'Open'
    ORDER BY PostedDate DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_Update]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Job_Update]
    @Id INT,
    @Title NVARCHAR(256),
    @Description NVARCHAR(MAX),
    @Requirements NVARCHAR(MAX) = NULL,
    @Responsibilities NVARCHAR(MAX) = NULL,
    @Location NVARCHAR(256),
    @EmploymentType NVARCHAR(100) = NULL,
    @SalaryMin DECIMAL(18,2) = NULL,
    @SalaryMax DECIMAL(18,2) = NULL,
    @ExperienceYearsMin INT = NULL,
    @ExperienceYearsMax INT = NULL,
    @Skills NVARCHAR(MAX) = NULL,
    @Department NVARCHAR(256),
    @Status NVARCHAR(50),
    @ClosedDate DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Jobs SET
        Title = @Title, Description = @Description, Requirements = @Requirements,
        Responsibilities = @Responsibilities, Location = @Location, EmploymentType = @EmploymentType,
        SalaryMin = @SalaryMin, SalaryMax = @SalaryMax, ExperienceYearsMin = @ExperienceYearsMin,
        ExperienceYearsMax = @ExperienceYearsMax, Skills = @Skills, Department = @Department,
        Status = @Status, ClosedDate = @ClosedDate, UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Job_UpdateFull]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Job_UpdateFull]
    @Id INT,
    @Title NVARCHAR(256),
    @Description NVARCHAR(MAX),
    @Requirements NVARCHAR(MAX) = NULL,
    @Responsibilities NVARCHAR(MAX) = NULL,
    @Location NVARCHAR(256),
    @EmploymentType NVARCHAR(100) = NULL,
    @SalaryMin DECIMAL(18,2) = NULL,
    @SalaryMax DECIMAL(18,2) = NULL,
    @ExperienceYearsMin INT = NULL,
    @ExperienceYearsMax INT = NULL,
    @Skills NVARCHAR(MAX) = NULL,
    @Department NVARCHAR(256),
    @Status NVARCHAR(50),
    @ClosedDate DATETIME2 = NULL,
    @MustHaveSkills NVARCHAR(MAX) = NULL,
    @NiceToHaveSkills NVARCHAR(MAX) = NULL,
    @EducationRequirement NVARCHAR(300) = NULL,
    @WorkMode NVARCHAR(30) = NULL,
    @BenefitsText NVARCHAR(MAX) = NULL,
    @LegalText NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Jobs SET
        Title = @Title, Description = @Description, Requirements = @Requirements,
        Responsibilities = @Responsibilities, Location = @Location, EmploymentType = @EmploymentType,
        SalaryMin = @SalaryMin, SalaryMax = @SalaryMax, ExperienceYearsMin = @ExperienceYearsMin,
        ExperienceYearsMax = @ExperienceYearsMax, Skills = @Skills, Department = @Department,
        Status = @Status, ClosedDate = @ClosedDate, MustHaveSkills = @MustHaveSkills,
        NiceToHaveSkills = @NiceToHaveSkills, EducationRequirement = @EducationRequirement,
        WorkMode = @WorkMode, BenefitsText = @BenefitsText, LegalText = @LegalText,
        UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobFamily_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_JobFamily_Create] @Name NVARCHAR(150), @Description NVARCHAR(500) = NULL AS BEGIN SET NOCOUNT ON; INSERT INTO dbo.JobFamilies (Name, Description) VALUES (@Name, @Description); SELECT CAST(SCOPE_IDENTITY() AS INT); END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobFamily_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_JobFamily_Delete] @Id INT AS BEGIN SET NOCOUNT ON; UPDATE dbo.JobFamilies SET IsActive = 0 WHERE Id = @Id; SELECT @@ROWCOUNT; END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobFamily_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_JobFamily_GetAll] AS BEGIN SET NOCOUNT ON; SELECT Id, Name, Description, IsActive FROM dbo.JobFamilies WHERE IsActive = 1 ORDER BY Name; END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobPostingChannel_Add]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: job publishing / distribution channels
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_JobPostingChannel_Add]
    @JobId INT,
    @Channel NVARCHAR(50),
    @ExternalUrl NVARCHAR(500) = NULL,
    @ExpiryDate DATETIME2 = NULL,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.JobPostingChannels (JobId, Channel, ExternalUrl, ExpiryDate, CreatedBy)
    VALUES (@JobId, @Channel, @ExternalUrl, @ExpiryDate, @CreatedBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobPostingChannel_GetByJobId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_JobPostingChannel_GetByJobId]
    @JobId INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Auto-expire anything past its expiry date before reporting status.
    UPDATE dbo.JobPostingChannels SET Status = 'Expired'
    WHERE JobId = @JobId AND Status = 'Active' AND ExpiryDate IS NOT NULL AND ExpiryDate < SYSUTCDATETIME();

    SELECT Id, JobId, Channel, Status, ExternalUrl, PostedAt, ExpiryDate, CreatedBy
    FROM dbo.JobPostingChannels
    WHERE JobId = @JobId
    ORDER BY PostedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobPostingChannel_UpdateStatus]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_JobPostingChannel_UpdateStatus]
    @Id INT,
    @Status NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.JobPostingChannels SET Status = @Status WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobRequisition_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_JobRequisition_Create]
    @Title NVARCHAR(256),
    @Department NVARCHAR(256),
    @Location NVARCHAR(256),
    @EmploymentType NVARCHAR(100) = NULL,
    @Vacancies INT,
    @Priority NVARCHAR(50),
    @RequisitionType NVARCHAR(50),
    @TargetJoiningDate DATETIME2 = NULL,
    @BudgetReference NVARCHAR(200) = NULL,
    @JustificationNotes NVARCHAR(MAX) = NULL,
    @RequiredSkills NVARCHAR(MAX) = NULL,
    @HiringManagerId INT = NULL,
    @RecruiterId INT = NULL,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.JobRequisitions
        (Title, Department, Location, EmploymentType, Vacancies, Priority, RequisitionType,
         TargetJoiningDate, BudgetReference, JustificationNotes, RequiredSkills,
         HiringManagerId, RecruiterId, Status, CreatedBy)
    VALUES
        (@Title, @Department, @Location, @EmploymentType, @Vacancies, @Priority, @RequisitionType,
         @TargetJoiningDate, @BudgetReference, @JustificationNotes, @RequiredSkills,
         @HiringManagerId, @RecruiterId, 'Draft', @CreatedBy);

    DECLARE @NewId INT = CAST(SCOPE_IDENTITY() AS INT);

    INSERT INTO dbo.JobRequisitionAudit (JobRequisitionId, Action, FromStatus, ToStatus, PerformedBy, Notes)
    VALUES (@NewId, 'Created', NULL, 'Draft', @CreatedBy, NULL);

    SELECT @NewId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobRequisition_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_JobRequisition_Delete]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.JobRequisitionAudit WHERE JobRequisitionId = @Id;
    DELETE FROM dbo.JobRequisitions WHERE Id = @Id AND Status = 'Draft';
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobRequisition_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: dbo.JobRequisitions
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_JobRequisition_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Title, Department, Location, EmploymentType, Vacancies, Priority, RequisitionType,
           TargetJoiningDate, BudgetReference, JustificationNotes, RequiredSkills,
           HiringManagerId, RecruiterId, JobId, Status, ApprovedBy, ApprovedAt, RejectionReason,
           CreatedBy, CreatedAt, UpdatedAt
    FROM dbo.JobRequisitions
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobRequisition_GetAudit]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_JobRequisition_GetAudit]
    @JobRequisitionId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, JobRequisitionId, Action, FromStatus, ToStatus, PerformedBy, Notes, PerformedAt
    FROM dbo.JobRequisitionAudit
    WHERE JobRequisitionId = @JobRequisitionId
    ORDER BY PerformedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobRequisition_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_JobRequisition_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Title, Department, Location, EmploymentType, Vacancies, Priority, RequisitionType,
           TargetJoiningDate, BudgetReference, JustificationNotes, RequiredSkills,
           HiringManagerId, RecruiterId, JobId, Status, ApprovedBy, ApprovedAt, RejectionReason,
           CreatedBy, CreatedAt, UpdatedAt
    FROM dbo.JobRequisitions
    WHERE Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobRequisition_LinkJob]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_JobRequisition_LinkJob]
    @Id INT,
    @JobId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.JobRequisitions
    SET JobId = @JobId, UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobRequisition_Update]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_JobRequisition_Update]
    @Id INT,
    @Title NVARCHAR(256),
    @Department NVARCHAR(256),
    @Location NVARCHAR(256),
    @EmploymentType NVARCHAR(100) = NULL,
    @Vacancies INT,
    @Priority NVARCHAR(50),
    @RequisitionType NVARCHAR(50),
    @TargetJoiningDate DATETIME2 = NULL,
    @BudgetReference NVARCHAR(200) = NULL,
    @JustificationNotes NVARCHAR(MAX) = NULL,
    @RequiredSkills NVARCHAR(MAX) = NULL,
    @HiringManagerId INT = NULL,
    @RecruiterId INT = NULL,
    @JobId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.JobRequisitions SET
        Title = @Title, Department = @Department, Location = @Location, EmploymentType = @EmploymentType,
        Vacancies = @Vacancies, Priority = @Priority, RequisitionType = @RequisitionType,
        TargetJoiningDate = @TargetJoiningDate, BudgetReference = @BudgetReference,
        JustificationNotes = @JustificationNotes, RequiredSkills = @RequiredSkills,
        HiringManagerId = @HiringManagerId, RecruiterId = @RecruiterId, JobId = @JobId,
        UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id AND Status IN ('Draft', 'OnHold');

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_JobRequisition_UpdateStatus]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Handles submit/approve/reject/hold/reopen/close as one auditable status transition.
CREATE   PROCEDURE [dbo].[sp_JobRequisition_UpdateStatus]
    @Id INT,
    @NewStatus NVARCHAR(50),
    @PerformedBy INT = NULL,
    @RejectionReason NVARCHAR(500) = NULL,
    @Notes NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentStatus NVARCHAR(50);
    SELECT @CurrentStatus = Status FROM dbo.JobRequisitions WHERE Id = @Id;

    IF @CurrentStatus IS NULL
    BEGIN
        SELECT CAST(0 AS INT) AS RowsAffected;
        RETURN;
    END

    UPDATE dbo.JobRequisitions
    SET Status = @NewStatus,
        ApprovedBy = CASE WHEN @NewStatus = 'Approved' THEN @PerformedBy ELSE ApprovedBy END,
        ApprovedAt = CASE WHEN @NewStatus = 'Approved' THEN SYSUTCDATETIME() ELSE ApprovedAt END,
        RejectionReason = CASE WHEN @NewStatus = 'Rejected' THEN @RejectionReason ELSE RejectionReason END,
        UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    INSERT INTO dbo.JobRequisitionAudit (JobRequisitionId, Action, FromStatus, ToStatus, PerformedBy, Notes)
    VALUES (@Id, @NewStatus, @CurrentStatus, @NewStatus, @PerformedBy, COALESCE(@RejectionReason, @Notes));

    SELECT CAST(1 AS INT) AS RowsAffected;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Lookup_GetCountries]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: dbo.Lookups / Countries / States
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Lookup_GetCountries]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Code, Name FROM dbo.Countries ORDER BY Name;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Lookup_GetStates]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Lookup_GetStates]
    @CountryId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CountryId, Name
    FROM dbo.States
    WHERE CountryId = @CountryId
    ORDER BY Name;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Lookup_GetValuesByCategory]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Lookup_GetValuesByCategory]
    @Category NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Value
    FROM dbo.Lookups
    WHERE Category = @Category AND IsActive = 1
    ORDER BY SortOrder, Value;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Offer_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: dbo.Offers
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Offer_Create]
    @CandidateId INT,
    @JobId INT = NULL,
    @BaseSalary DECIMAL(18,2),
    @Bonus DECIMAL(18,2) = NULL,
    @EquityDetails NVARCHAR(300) = NULL,
    @OtherBenefits NVARCHAR(1000) = NULL,
    @TotalCtc DECIMAL(18,2) = NULL,
    @ValidUntil DATETIME2 = NULL,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Offers (CandidateId, JobId, BaseSalary, Bonus, EquityDetails, OtherBenefits, TotalCtc, ValidUntil, Status, CreatedBy)
    VALUES (@CandidateId, @JobId, @BaseSalary, @Bonus, @EquityDetails, @OtherBenefits, @TotalCtc, @ValidUntil, 'Draft', @CreatedBy);

    DECLARE @NewId INT = CAST(SCOPE_IDENTITY() AS INT);

    INSERT INTO dbo.OfferAudit (OfferId, Action, FromStatus, ToStatus, PerformedBy)
    VALUES (@NewId, 'Created', NULL, 'Draft', @CreatedBy);

    SELECT @NewId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Offer_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Offer_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, JobId, BaseSalary, Bonus, EquityDetails, OtherBenefits, TotalCtc, ValidUntil,
           Status, SignedDocumentUrl, ApprovedBy, ApprovedAt, SentAt, RespondedAt, CreatedBy, CreatedAt, UpdatedAt
    FROM dbo.Offers
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Offer_GetAudit]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Offer_GetAudit]
    @OfferId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, OfferId, Action, FromStatus, ToStatus, PerformedBy, Notes, PerformedAt
    FROM dbo.OfferAudit
    WHERE OfferId = @OfferId
    ORDER BY PerformedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Offer_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Offer_GetByCandidateId]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, JobId, BaseSalary, Bonus, EquityDetails, OtherBenefits, TotalCtc, ValidUntil,
           Status, SignedDocumentUrl, ApprovedBy, ApprovedAt, SentAt, RespondedAt, CreatedBy, CreatedAt, UpdatedAt
    FROM dbo.Offers
    WHERE CandidateId = @CandidateId
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Offer_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Offer_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, JobId, BaseSalary, Bonus, EquityDetails, OtherBenefits, TotalCtc, ValidUntil,
           Status, SignedDocumentUrl, ApprovedBy, ApprovedAt, SentAt, RespondedAt, CreatedBy, CreatedAt, UpdatedAt
    FROM dbo.Offers WHERE Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Offer_LogNegotiation]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Offer_LogNegotiation]
    @OfferId INT,
    @Notes NVARCHAR(1000),
    @NewBaseSalary DECIMAL(18,2) = NULL,
    @NewTotalCtc DECIMAL(18,2) = NULL,
    @PerformedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @NewBaseSalary IS NOT NULL OR @NewTotalCtc IS NOT NULL
    BEGIN
        UPDATE dbo.Offers
        SET BaseSalary = COALESCE(@NewBaseSalary, BaseSalary),
            TotalCtc = COALESCE(@NewTotalCtc, TotalCtc),
            UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @OfferId;
    END

    INSERT INTO dbo.OfferAudit (OfferId, Action, PerformedBy, Notes)
    VALUES (@OfferId, 'Negotiation', @PerformedBy, @Notes);

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Offer_Update]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Offer_Update]
    @Id INT,
    @BaseSalary DECIMAL(18,2),
    @Bonus DECIMAL(18,2) = NULL,
    @EquityDetails NVARCHAR(300) = NULL,
    @OtherBenefits NVARCHAR(1000) = NULL,
    @TotalCtc DECIMAL(18,2) = NULL,
    @ValidUntil DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Offers SET
        BaseSalary = @BaseSalary, Bonus = @Bonus, EquityDetails = @EquityDetails,
        OtherBenefits = @OtherBenefits, TotalCtc = @TotalCtc, ValidUntil = @ValidUntil,
        UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id AND Status = 'Draft';

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Offer_UpdateStatus]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Handles submit/approve/reject/send/accept/decline/withdraw as one auditable transition.
-- Accepting cascades: candidate -> "Offer Accepted" stage, a pre-joining checklist, and a Hire event.
CREATE   PROCEDURE [dbo].[sp_Offer_UpdateStatus]
    @Id INT,
    @NewStatus NVARCHAR(30),
    @PerformedBy INT = NULL,
    @Notes NVARCHAR(1000) = NULL,
    @SignedDocumentUrl NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentStatus NVARCHAR(30), @CandidateId INT;
    SELECT @CurrentStatus = Status, @CandidateId = CandidateId FROM dbo.Offers WHERE Id = @Id;

    IF @CurrentStatus IS NULL
    BEGIN
        SELECT CAST(0 AS INT) AS RowsAffected;
        RETURN;
    END

    UPDATE dbo.Offers
    SET Status = @NewStatus,
        ApprovedBy = CASE WHEN @NewStatus = 'Approved' THEN @PerformedBy ELSE ApprovedBy END,
        ApprovedAt = CASE WHEN @NewStatus = 'Approved' THEN SYSUTCDATETIME() ELSE ApprovedAt END,
        SentAt = CASE WHEN @NewStatus = 'Sent' THEN SYSUTCDATETIME() ELSE SentAt END,
        RespondedAt = CASE WHEN @NewStatus IN ('Accepted', 'Rejected') THEN SYSUTCDATETIME() ELSE RespondedAt END,
        SignedDocumentUrl = COALESCE(@SignedDocumentUrl, SignedDocumentUrl),
        UpdatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    INSERT INTO dbo.OfferAudit (OfferId, Action, FromStatus, ToStatus, PerformedBy, Notes)
    VALUES (@Id, @NewStatus, @CurrentStatus, @NewStatus, @PerformedBy, @Notes);

    IF @NewStatus = 'Accepted'
    BEGIN
        EXEC dbo.sp_Candidate_ChangeStage @CandidateId = @CandidateId, @NewStatus = 'Offer Accepted', @ChangedBy = @PerformedBy, @Reason = 'Offer accepted';
        EXEC dbo.sp_PreJoining_CreateChecklist @CandidateId = @CandidateId, @OfferId = @Id;

        DECLARE @Payload NVARCHAR(MAX) = (
            SELECT c.Id AS candidateId, c.FirstName AS firstName, c.LastName AS lastName, c.Email AS email,
                   o.Id AS offerId, o.BaseSalary AS baseSalary, o.TotalCtc AS totalCtc
            FROM dbo.Candidates c INNER JOIN dbo.Offers o ON o.Id = @Id
            WHERE c.Id = @CandidateId
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        );
        INSERT INTO dbo.HireEvents (CandidateId, OfferId, Payload, Status)
        VALUES (@CandidateId, @Id, @Payload, 'Pending');
    END
    ELSE IF @NewStatus = 'Rejected'
        EXEC dbo.sp_Candidate_ChangeStage @CandidateId = @CandidateId, @NewStatus = 'Offer Declined', @ChangedBy = @PerformedBy, @Reason = 'Offer declined by candidate';
    ELSE IF @NewStatus = 'Withdrawn'
        EXEC dbo.sp_Candidate_ChangeStage @CandidateId = @CandidateId, @NewStatus = 'Rejected', @ChangedBy = @PerformedBy, @Reason = 'Offer withdrawn by employer';

    SELECT CAST(1 AS INT) AS RowsAffected;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_OfficeLocation_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_OfficeLocation_Create] @Name NVARCHAR(150), @City NVARCHAR(100) = NULL, @Country NVARCHAR(100) = NULL AS BEGIN SET NOCOUNT ON; INSERT INTO dbo.OfficeLocations (Name, City, Country) VALUES (@Name, @City, @Country); SELECT CAST(SCOPE_IDENTITY() AS INT); END

GO
/****** Object:  StoredProcedure [dbo].[sp_OfficeLocation_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_OfficeLocation_Delete] @Id INT AS BEGIN SET NOCOUNT ON; UPDATE dbo.OfficeLocations SET IsActive = 0 WHERE Id = @Id; SELECT @@ROWCOUNT; END

GO
/****** Object:  StoredProcedure [dbo].[sp_OfficeLocation_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_OfficeLocation_GetAll] AS BEGIN SET NOCOUNT ON; SELECT Id, Name, City, Country, IsActive FROM dbo.OfficeLocations WHERE IsActive = 1 ORDER BY Name; END

GO
/****** Object:  StoredProcedure [dbo].[sp_PreJoining_CreateChecklist]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: Pre-Joining / Onboarding
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_PreJoining_CreateChecklist]
    @CandidateId INT,
    @OfferId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.PreJoiningChecklists WHERE OfferId = @OfferId)
    BEGIN
        SELECT Id FROM dbo.PreJoiningChecklists WHERE OfferId = @OfferId;
        RETURN;
    END

    INSERT INTO dbo.PreJoiningChecklists (CandidateId, OfferId)
    VALUES (@CandidateId, @OfferId);

    DECLARE @ChecklistId INT = CAST(SCOPE_IDENTITY() AS INT);

    INSERT INTO dbo.PreJoiningTasks (ChecklistId, TaskName, SortOrder) VALUES
        (@ChecklistId, 'Countersigned offer letter received', 1),
        (@ChecklistId, 'Government ID proof submitted', 2),
        (@ChecklistId, 'Educational certificates submitted', 3),
        (@ChecklistId, 'Previous employment relieving letter submitted', 4),
        (@ChecklistId, 'Background verification consent signed', 5),
        (@ChecklistId, 'Bank account details collected', 6),
        (@ChecklistId, 'IT equipment / access request raised', 7);

    SELECT @ChecklistId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PreJoining_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_PreJoining_GetByCandidateId]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, CandidateId, OfferId, JoiningDate, BgvStatus, CreatedAt, UpdatedAt
    FROM dbo.PreJoiningChecklists
    WHERE CandidateId = @CandidateId
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PreJoining_GetTasks]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_PreJoining_GetTasks]
    @ChecklistId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, ChecklistId, TaskName, IsCompleted, CompletedAt, Notes, SortOrder
    FROM dbo.PreJoiningTasks
    WHERE ChecklistId = @ChecklistId
    ORDER BY SortOrder;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PreJoining_SetJoiningDate]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_PreJoining_SetJoiningDate]
    @ChecklistId INT,
    @JoiningDate DATETIME2
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.PreJoiningChecklists SET JoiningDate = @JoiningDate, UpdatedAt = SYSUTCDATETIME() WHERE Id = @ChecklistId;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PreJoining_UpdateBgvStatus]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_PreJoining_UpdateBgvStatus]
    @ChecklistId INT,
    @BgvStatus NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.PreJoiningChecklists SET BgvStatus = @BgvStatus, UpdatedAt = SYSUTCDATETIME() WHERE Id = @ChecklistId;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PreJoiningTask_Add]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_PreJoiningTask_Add]
    @ChecklistId INT,
    @TaskName NVARCHAR(200),
    @SortOrder INT = 99
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.PreJoiningTasks (ChecklistId, TaskName, SortOrder) VALUES (@ChecklistId, @TaskName, @SortOrder);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PreJoiningTask_Toggle]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_PreJoiningTask_Toggle]
    @Id INT,
    @IsCompleted BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.PreJoiningTasks
    SET IsCompleted = @IsCompleted, CompletedAt = CASE WHEN @IsCompleted = 1 THEN SYSUTCDATETIME() ELSE NULL END
    WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Referral_AttachCandidate]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Referral_AttachCandidate]
    @ReferralCode NVARCHAR(20), @CandidateId INT
AS BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Referrals SET CandidateId = @CandidateId, Status = 'Submitted'
    WHERE ReferralCode = @ReferralCode AND CandidateId IS NULL;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Referral_CreateLink]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: Employee referrals
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_Referral_CreateLink]
    @ReferrerUserId INT, @JobId INT
AS BEGIN
    SET NOCOUNT ON;
    DECLARE @Code NVARCHAR(20) = UPPER(LEFT(CONVERT(NVARCHAR(36), NEWID()), 8));

    INSERT INTO dbo.Referrals (ReferrerUserId, JobId, ReferralCode, Status)
    VALUES (@ReferrerUserId, @JobId, @Code, 'LinkGenerated');

    SELECT CAST(SCOPE_IDENTITY() AS INT) AS Id, @Code AS ReferralCode;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Referral_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Referral_GetAll]
AS BEGIN
    SET NOCOUNT ON;
    SELECT r.Id, r.ReferrerUserId, u.FullName AS ReferrerName, r.JobId, j.Title AS JobTitle, r.CandidateId,
           c.FirstName, c.LastName, r.ReferralCode, r.Status, r.BonusAmount, r.BonusStatus, r.CreatedAt
    FROM dbo.Referrals r
    INNER JOIN dbo.Users u ON u.Id = r.ReferrerUserId
    INNER JOIN dbo.Jobs j ON j.Id = r.JobId
    LEFT JOIN dbo.Candidates c ON c.Id = r.CandidateId
    ORDER BY r.CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Referral_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Referral_GetByCandidateId]
    @CandidateId INT
AS BEGIN
    SET NOCOUNT ON;
    SELECT Id, ReferrerUserId, JobId, CandidateId, ReferralCode, Status, BonusAmount, BonusStatus, CreatedAt
    FROM dbo.Referrals WHERE CandidateId = @CandidateId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Referral_GetByCode]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Referral_GetByCode]
    @ReferralCode NVARCHAR(20)
AS BEGIN
    SET NOCOUNT ON;
    SELECT r.Id, r.ReferrerUserId, r.JobId, j.Title AS JobTitle, r.CandidateId, r.ReferralCode, r.Status, r.BonusAmount, r.BonusStatus, r.CreatedAt
    FROM dbo.Referrals r
    INNER JOIN dbo.Jobs j ON j.Id = r.JobId
    WHERE r.ReferralCode = @ReferralCode;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Referral_GetByReferrer]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Referral_GetByReferrer]
    @ReferrerUserId INT
AS BEGIN
    SET NOCOUNT ON;
    SELECT r.Id, r.ReferrerUserId, r.JobId, j.Title AS JobTitle, r.CandidateId,
           c.FirstName, c.LastName, r.ReferralCode, r.Status, r.BonusAmount, r.BonusStatus, r.CreatedAt
    FROM dbo.Referrals r
    INNER JOIN dbo.Jobs j ON j.Id = r.JobId
    LEFT JOIN dbo.Candidates c ON c.Id = r.CandidateId
    WHERE r.ReferrerUserId = @ReferrerUserId
    ORDER BY r.CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Referral_UpdateBonus]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_Referral_UpdateBonus]
    @Id INT, @BonusAmount DECIMAL(18,2) = NULL, @BonusStatus NVARCHAR(20)
AS BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Referrals SET BonusAmount = COALESCE(@BonusAmount, BonusAmount), BonusStatus = @BonusStatus WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SalaryBand_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_SalaryBand_Create]
    @JobFamilyId INT = NULL, @Level NVARCHAR(100), @MinSalary DECIMAL(18,2), @MaxSalary DECIMAL(18,2), @Currency NVARCHAR(10) = 'INR'
AS BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.SalaryBands (JobFamilyId, Level, MinSalary, MaxSalary, Currency) VALUES (@JobFamilyId, @Level, @MinSalary, @MaxSalary, @Currency);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SalaryBand_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_SalaryBand_Delete] @Id INT AS BEGIN SET NOCOUNT ON; UPDATE dbo.SalaryBands SET IsActive = 0 WHERE Id = @Id; SELECT @@ROWCOUNT; END

GO
/****** Object:  StoredProcedure [dbo].[sp_SalaryBand_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_SalaryBand_GetAll]
AS BEGIN
    SET NOCOUNT ON;
    SELECT b.Id, b.JobFamilyId, f.Name AS JobFamilyName, b.Level, b.MinSalary, b.MaxSalary, b.Currency, b.IsActive
    FROM dbo.SalaryBands b
    LEFT JOIN dbo.JobFamilies f ON f.Id = b.JobFamilyId
    WHERE b.IsActive = 1
    ORDER BY f.Name, b.MinSalary;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SavedSearch_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_SavedSearch_Create]
    @UserId INT,
    @Name NVARCHAR(150),
    @Keyword NVARCHAR(200) = NULL,
    @MinExperience DECIMAL(5,2) = NULL,
    @MaxExperience DECIMAL(5,2) = NULL,
    @Location NVARCHAR(150) = NULL,
    @Status NVARCHAR(50) = NULL,
    @Source NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.SavedSearches (UserId, Name, Keyword, MinExperience, MaxExperience, Location, Status, Source)
    VALUES (@UserId, @Name, @Keyword, @MinExperience, @MaxExperience, @Location, @Status, @Source);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SavedSearch_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_SavedSearch_Delete]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.SavedSearches WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SavedSearch_GetByUserId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_SavedSearch_GetByUserId]
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, UserId, Name, Keyword, MinExperience, MaxExperience, Location, Status, Source, CreatedAt
    FROM dbo.SavedSearches
    WHERE UserId = @UserId
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningForm_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_ScreeningForm_Create]
    @JobId INT = NULL,
    @Title NVARCHAR(256),
    @Description NVARCHAR(500) = NULL,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.ScreeningForms (JobId, Title, Description, CreatedBy)
    VALUES (@JobId, @Title, @Description, @CreatedBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningForm_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_ScreeningForm_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, JobId, Title, Description, IsActive, CreatedBy, CreatedAt
    FROM dbo.ScreeningForms
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningForm_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_ScreeningForm_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, JobId, Title, Description, IsActive, CreatedBy, CreatedAt
    FROM dbo.ScreeningForms WHERE Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningQuestion_Add]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_ScreeningQuestion_Add]
    @ScreeningFormId INT,
    @QuestionText NVARCHAR(500),
    @QuestionType NVARCHAR(30),
    @Options NVARCHAR(500) = NULL,
    @IsKnockout BIT = 0,
    @ExpectedAnswer NVARCHAR(200) = NULL,
    @SortOrder INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.ScreeningQuestions (ScreeningFormId, QuestionText, QuestionType, Options, IsKnockout, ExpectedAnswer, SortOrder)
    VALUES (@ScreeningFormId, @QuestionText, @QuestionType, @Options, @IsKnockout, @ExpectedAnswer, @SortOrder);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningQuestion_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_ScreeningQuestion_Delete]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.ScreeningQuestions WHERE Id = @Id;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningQuestion_GetByFormId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_ScreeningQuestion_GetByFormId]
    @ScreeningFormId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, ScreeningFormId, QuestionText, QuestionType, Options, IsKnockout, ExpectedAnswer, SortOrder
    FROM dbo.ScreeningQuestions
    WHERE ScreeningFormId = @ScreeningFormId
    ORDER BY SortOrder, Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningResponse_GetAnswers]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_ScreeningResponse_GetAnswers]
    @ScreeningResponseId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT a.Id, a.ScreeningResponseId, a.QuestionId, q.QuestionText, q.IsKnockout, a.AnswerText, a.PassedKnockout
    FROM dbo.ScreeningAnswers a
    INNER JOIN dbo.ScreeningQuestions q ON q.Id = a.QuestionId
    WHERE a.ScreeningResponseId = @ScreeningResponseId
    ORDER BY q.SortOrder;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningResponse_GetByCandidateId]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_ScreeningResponse_GetByCandidateId]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.Id, r.CandidateId, r.ScreeningFormId, f.Title AS FormTitle, r.SubmittedAt, r.KnockoutFailed,
           r.OverallScore, r.Recommendation, r.RecruiterNotes, r.EvaluatedBy, r.EvaluatedAt
    FROM dbo.ScreeningResponses r
    INNER JOIN dbo.ScreeningForms f ON f.Id = r.ScreeningFormId
    WHERE r.CandidateId = @CandidateId
    ORDER BY r.SubmittedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningResponse_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_ScreeningResponse_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.Id, r.CandidateId, r.ScreeningFormId, f.Title AS FormTitle, r.SubmittedAt, r.KnockoutFailed,
           r.OverallScore, r.Recommendation, r.RecruiterNotes, r.EvaluatedBy, r.EvaluatedAt
    FROM dbo.ScreeningResponses r
    INNER JOIN dbo.ScreeningForms f ON f.Id = r.ScreeningFormId
    WHERE r.Id = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningResponse_Submit]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- @AnswersJson: '[{"QuestionId":1,"AnswerText":"Yes"}, ...]'
-- Auto-evaluates knockout questions and, on failure, moves the candidate to Rejected
-- (implements the spec's "when knockout condition fails -> move to rejected" automation rule).
CREATE   PROCEDURE [dbo].[sp_ScreeningResponse_Submit]
    @CandidateId INT,
    @ScreeningFormId INT,
    @EvaluatedBy INT = NULL,
    @RecruiterNotes NVARCHAR(MAX) = NULL,
    @AnswersJson NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.ScreeningResponses (CandidateId, ScreeningFormId, EvaluatedBy, EvaluatedAt, RecruiterNotes)
    VALUES (@CandidateId, @ScreeningFormId, @EvaluatedBy, SYSUTCDATETIME(), @RecruiterNotes);

    DECLARE @NewId INT = CAST(SCOPE_IDENTITY() AS INT);

    INSERT INTO dbo.ScreeningAnswers (ScreeningResponseId, QuestionId, AnswerText)
    SELECT @NewId, QuestionId, AnswerText
    FROM OPENJSON(@AnswersJson)
    WITH (QuestionId INT '$.QuestionId', AnswerText NVARCHAR(MAX) '$.AnswerText');

    UPDATE sa
    SET sa.PassedKnockout = CASE
        WHEN q.IsKnockout = 1 THEN CASE WHEN sa.AnswerText = q.ExpectedAnswer THEN 1 ELSE 0 END
        ELSE NULL
    END
    FROM dbo.ScreeningAnswers sa
    INNER JOIN dbo.ScreeningQuestions q ON q.Id = sa.QuestionId
    WHERE sa.ScreeningResponseId = @NewId;

    DECLARE @KnockoutFailed BIT = 0;
    IF EXISTS (SELECT 1 FROM dbo.ScreeningAnswers WHERE ScreeningResponseId = @NewId AND PassedKnockout = 0)
        SET @KnockoutFailed = 1;

    UPDATE dbo.ScreeningResponses
    SET KnockoutFailed = @KnockoutFailed,
        Recommendation = CASE WHEN @KnockoutFailed = 1 THEN 'Reject' ELSE Recommendation END
    WHERE Id = @NewId;

    IF @KnockoutFailed = 1
    BEGIN
        EXEC dbo.sp_Candidate_ChangeStage
            @CandidateId = @CandidateId,
            @NewStatus = 'Rejected',
            @ChangedBy = @EvaluatedBy,
            @Reason = 'Failed knockout screening question(s)';
    END

    SELECT @NewId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ScreeningResponse_UpdateRecommendation]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Recruiter's final call after reviewing a screening response: Shortlist / Reject / Hold.
-- Mirrors the resulting pipeline stage so the two stay consistent.
CREATE   PROCEDURE [dbo].[sp_ScreeningResponse_UpdateRecommendation]
    @Id INT,
    @Recommendation NVARCHAR(20),
    @OverallScore INT = NULL,
    @RecruiterNotes NVARCHAR(MAX) = NULL,
    @EvaluatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CandidateId INT;
    SELECT @CandidateId = CandidateId FROM dbo.ScreeningResponses WHERE Id = @Id;

    UPDATE dbo.ScreeningResponses
    SET Recommendation = @Recommendation, OverallScore = @OverallScore,
        RecruiterNotes = COALESCE(@RecruiterNotes, RecruiterNotes),
        EvaluatedBy = @EvaluatedBy, EvaluatedAt = SYSUTCDATETIME()
    WHERE Id = @Id;

    IF @CandidateId IS NOT NULL AND @Recommendation = 'Shortlist'
        EXEC dbo.sp_Candidate_ChangeStage @CandidateId = @CandidateId, @NewStatus = 'Shortlisted', @ChangedBy = @EvaluatedBy, @Reason = 'Passed structured screening';
    ELSE IF @CandidateId IS NOT NULL AND @Recommendation = 'Reject'
        EXEC dbo.sp_Candidate_ChangeStage @CandidateId = @CandidateId, @NewStatus = 'Rejected', @ChangedBy = @EvaluatedBy, @Reason = 'Did not pass screening review';

    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SkillMaster_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_SkillMaster_Create] @Name NVARCHAR(100), @Category NVARCHAR(100) = NULL AS BEGIN SET NOCOUNT ON; IF NOT EXISTS (SELECT 1 FROM dbo.SkillsMaster WHERE Name = @Name) INSERT INTO dbo.SkillsMaster (Name, Category) VALUES (@Name, @Category); SELECT CAST(SCOPE_IDENTITY() AS INT); END

GO
/****** Object:  StoredProcedure [dbo].[sp_SkillMaster_Delete]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[sp_SkillMaster_Delete] @Id INT AS BEGIN SET NOCOUNT ON; UPDATE dbo.SkillsMaster SET IsActive = 0 WHERE Id = @Id; SELECT @@ROWCOUNT; END

GO
/****** Object:  StoredProcedure [dbo].[sp_SkillMaster_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_SkillMaster_GetAll] AS BEGIN SET NOCOUNT ON; SELECT Id, Name, Category, IsActive FROM dbo.SkillsMaster WHERE IsActive = 1 ORDER BY Name; END

GO
/****** Object:  StoredProcedure [dbo].[sp_SmtpSettings_GetActive]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_SmtpSettings_GetActive]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 Id, Provider, Host, Port, SecureSocketMode, Username, EncryptedPassword, FromEmail, FromName, IsActive, CreatedBy, CreatedAt, UpdatedAt
    FROM dbo.SmtpSettings
    WHERE IsActive = 1
    ORDER BY CreatedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SmtpSettings_Upsert]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: SMTP settings
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_SmtpSettings_Upsert]
    @Provider NVARCHAR(50),
    @Host NVARCHAR(200),
    @Port INT,
    @SecureSocketMode NVARCHAR(20),
    @Username NVARCHAR(256),
    @EncryptedPassword NVARCHAR(MAX),
    @FromEmail NVARCHAR(256),
    @FromName NVARCHAR(150) = NULL,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Single active configuration at a time: deactivate any existing, then insert the new one.
    UPDATE dbo.SmtpSettings SET IsActive = 0 WHERE IsActive = 1;

    INSERT INTO dbo.SmtpSettings (Provider, Host, Port, SecureSocketMode, Username, EncryptedPassword, FromEmail, FromName, IsActive, CreatedBy)
    VALUES (@Provider, @Host, @Port, @SecureSocketMode, @Username, @EncryptedPassword, @FromEmail, @FromName, 1, @CreatedBy);

    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_TalentPool_AddMember]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_TalentPool_AddMember]
    @TalentPoolId INT,
    @CandidateId INT,
    @AddedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.TalentPoolMembers WHERE TalentPoolId = @TalentPoolId AND CandidateId = @CandidateId)
        INSERT INTO dbo.TalentPoolMembers (TalentPoolId, CandidateId, AddedBy) VALUES (@TalentPoolId, @CandidateId, @AddedBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_TalentPool_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: talent pools
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_TalentPool_Create]
    @Name NVARCHAR(150),
    @Description NVARCHAR(500) = NULL,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.TalentPools (Name, Description, CreatedBy) VALUES (@Name, @Description, @CreatedBy);
    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_TalentPool_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_TalentPool_GetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.Id, p.Name, p.Description, p.CreatedBy, p.CreatedAt,
           (SELECT COUNT(*) FROM dbo.TalentPoolMembers m WHERE m.TalentPoolId = p.Id) AS MemberCount
    FROM dbo.TalentPools p
    ORDER BY p.Name;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_TalentPool_GetMembers]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_TalentPool_GetMembers]
    @TalentPoolId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.Id, c.FirstName, c.LastName, c.Email, c.PositionApplied, c.TotalExperience, c.Skills, c.Status,
           m.AddedAt
    FROM dbo.TalentPoolMembers m
    INNER JOIN dbo.Candidates c ON c.Id = m.CandidateId
    WHERE m.TalentPoolId = @TalentPoolId
    ORDER BY m.AddedAt DESC;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_TalentPool_GetPoolsForCandidate]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_TalentPool_GetPoolsForCandidate]
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.Id, p.Name
    FROM dbo.TalentPoolMembers m
    INNER JOIN dbo.TalentPools p ON p.Id = m.TalentPoolId
    WHERE m.CandidateId = @CandidateId;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_TalentPool_RemoveMember]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_TalentPool_RemoveMember]
    @TalentPoolId INT,
    @CandidateId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.TalentPoolMembers WHERE TalentPoolId = @TalentPoolId AND CandidateId = @CandidateId;
    SELECT @@ROWCOUNT;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Create]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_User_Create]
    @FullName NVARCHAR(256),
    @Email NVARCHAR(256),
    @PasswordHash NVARCHAR(MAX),
    @Role NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Users (FullName, Email, PasswordHash, Role)
    VALUES (@FullName, @Email, @PasswordHash, @Role);

    SELECT CAST(SCOPE_IDENTITY() AS INT);
END

GO
/****** Object:  StoredProcedure [dbo].[sp_User_GetAll]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_User_GetAll]
    @Role NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, FullName, Email, Role, CreatedAt
    FROM dbo.Users
    WHERE @Role IS NULL OR Role = @Role
    ORDER BY FullName;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_User_GetByEmail]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================================
-- STORED PROCEDURES: dbo.Users
-- =============================================================
CREATE   PROCEDURE [dbo].[sp_User_GetByEmail]
    @Email NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, FullName, Email, PasswordHash, Role,
           CASE WHEN COL_LENGTH('dbo.Users', 'AgencyId') IS NOT NULL THEN AgencyId ELSE NULL END AS AgencyId,
           CreatedAt
    FROM dbo.Users
    WHERE Email = @Email;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_User_GetById]    Script Date: 14-09-2026 1.50.03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE   PROCEDURE [dbo].[sp_User_GetById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, FullName, Email, PasswordHash, Role,
           CASE WHEN COL_LENGTH('dbo.Users', 'AgencyId') IS NOT NULL THEN AgencyId ELSE NULL END AS AgencyId,
           CreatedAt
    FROM dbo.Users
    WHERE Id = @Id;
END

GO
