--ALTER TABLE [Experiences]
--ADD CONSTRAINT fk_Experience_UserId_Users_UserId FOREIGN KEY (UserId)
--REFERENCES Users(UserId);

--ALTER TABLE [Projects]
--ADD CONSTRAINT fk_Projects_UserId_Users_UserId FOREIGN KEY (UserId)
--REFERENCES Users(UserId);

--ALTER TABLE [Projects]
--ADD CONSTRAINT fk_Projects_ExperienceId_Experiences_ExperienceId FOREIGN KEY (ExperienceId)
--REFERENCES Experiences(ExperienceId);

--ALTER TABLE [ProjLangDetails]
--ADD CONSTRAINT fk_ProjLangDetails_UserId_Users_UserId FOREIGN KEY (UserId)
--REFERENCES Users(UserId);

--ALTER TABLE [ProjLangDetails]
--ADD CONSTRAINT fk_ProjLangDetails_ProjectId_Projects_ProjectId FOREIGN KEY (ProjectId)
--REFERENCES Projects(ProjectId);

--ALTER TABLE [ProjLangDetails]
--ADD CONSTRAINT fk_ProjLangDetails_ProjectLanguageId_ProjectLanguages_ProjectLanguageId FOREIGN KEY (ProjectLanguageId)
--REFERENCES ProjectLanguages(ProjectLanguageId);

--alter table [dbo].[Experiences]
--drop CONSTRAINT fk_Experience_UserId_Users_UserId

--alter table [dbo].[Projects]
--drop CONSTRAINT fk_Projects_ExperienceId_Experiences_ExperienceId

--alter table [dbo].[ProjLangDetails]
--drop CONSTRAINT fk_ProjLangDetails_ProjectLanguageId_ProjectLanguages_ProjectLanguageId

--truncate table [dbo].[Experiences]
--truncate table [dbo].[Projects]
--truncate table [ProjLangDetails]

--select * from [dbo].[ProjectLanguages]

--delete from [Users]
--delete from [Experiences] 
--delete from [Projects]
--delete from [ProjLangDetails]

select * from [dbo].[Users] order by UserId desc
select * from [dbo].[Experiences] order by ExperienceId desc
select * from [dbo].[Projects] order by ProjectId desc
select * from [dbo].[ProjLangDetails] order by ProjLangDetailId desc