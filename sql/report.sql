USE [azDB]
GO
/****** Object:  User [mra]    Script Date: 1/28/2020 7:20:43 PM ******/
CREATE USER [mra] FOR LOGIN [mra] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [mra]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [mra]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [mra]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [mra]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [mra]
GO
ALTER ROLE [db_datareader] ADD MEMBER [mra]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [mra]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [mra]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [mra]
GO
/****** Object:  UserDefinedFunction [dbo].[all_income]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date, ,>
---- Description:	<Description, ,>
---- =============================================
--CREATE FUNCTION <Scalar_Function_Name, sysname, FunctionName> 
--(
--	-- Add the parameters for the function here
--	<@Param1, sysname, @p1> <Data_Type_For_Param1, , int>
--)
--RETURNS <Function_Data_Type, ,int>
--AS
--BEGIN
--	-- Declare the return variable here
--	DECLARE <@ResultVar, sysname, @Result> <Function_Data_Type, ,int>

--	-- Add the T-SQL statements to compute the return value here
--	SELECT <@ResultVar, sysname, @Result> = <@Param1, sysname, @p1>

--	-- Return the result of the function
--	RETURN <@ResultVar, sysname, @Result>

--END
--GO
/*محاسبه قیمت داروهای تحویل داده شده توسط داروخانه اعلامی*/
CREATE FUNCTION	[dbo].[all_income](@drugStoreId int)
RETURNS	float
AS 
BEGIN	
	RETURN	(SELECT	SUM(dp.end_price)
	FROM	azDB.dbo.DeliverdPrescription dp
	WHERE	dp.drugsotre_id = @drugStoreId)
END;
GO
/****** Object:  Table [dbo].[PationtCase]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PationtCase](
	[pationt_id] [int] NOT NULL,
	[illness] [nvarchar](30) NOT NULL,
	[entrance_time] [date] NULL,
	[national_id] [int] NOT NULL,
 CONSTRAINT [PK_PationtCase] PRIMARY KEY CLUSTERED 
(
	[pationt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pationt]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pationt](
	[name] [nvarchar](50) NULL,
	[age] [int] NULL,
	[address] [nvarchar](150) NULL,
	[gender] [char](1) NULL,
	[national_id] [int] NOT NULL,
 CONSTRAINT [PK_Pationt_1] PRIMARY KEY CLUSTERED 
(
	[national_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Pationt] UNIQUE NONCLUSTERED 
(
	[national_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Hospitalization]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hospitalization](
	[hospitalization_id] [int] NOT NULL,
	[pationt_id] [int] NOT NULL,
	[room_id] [int] NOT NULL,
	[h_doctor_id] [int] NOT NULL,
	[d_doctor_id] [int] NULL,
	[h_reception_id] [int] NOT NULL,
	[d_reception_id] [int] NULL,
	[clerk_id] [int] NOT NULL,
	[acc_clearing_date] [date] NULL,
	[hospitalization_date] [date] NULL,
	[discharging_date] [datetime] NULL,
	[price] [money] NULL,
 CONSTRAINT [PK_Hospitalization] PRIMARY KEY CLUSTERED 
(
	[hospitalization_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_2]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_2]
AS
SELECT        p.name, pc.illness, p.age, p.gender, h.hospitalization_date, h.acc_clearing_date
FROM            dbo.Hospitalization AS h INNER JOIN
                         dbo.PationtCase AS pc ON h.pationt_id = pc.pationt_id INNER JOIN
                         dbo.Pationt AS p ON pc.national_id = p.national_id
WHERE        (h.acc_clearing_date IS NOT NULL) AND (h.discharging_date IS NOT NULL)
GO
/****** Object:  Table [dbo].[DoctorsRelations]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoctorsRelations](
	[doctor1_id] [int] NOT NULL,
	[doctor2_id] [int] NOT NULL,
 CONSTRAINT [PK_DoctorsRelations] PRIMARY KEY CLUSTERED 
(
	[doctor1_id] ASC,
	[doctor2_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctor]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctor](
	[doctor_id] [int] NOT NULL,
	[part_id] [int] NOT NULL,
	[name] [nvarchar](50) NULL,
	[enter_data] [date] NULL,
 CONSTRAINT [PK_Doctor] PRIMARY KEY CLUSTERED 
(
	[doctor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[FindDoctorRelationsss]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Multi-Statement Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE FUNCTION <Table_Function_Name, sysname, FunctionName> 
--(
--	-- Add the parameters for the function here
--	<@param1, sysname, @p1> <data_type_for_param1, , int>, 
--	<@param2, sysname, @p2> <data_type_for_param2, , char>
--)
--RETURNS 
--<@Table_Variable_Name, sysname, @Table_Var> TABLE 
--(
--	-- Add the column definitions for the TABLE variable here
--	<Column_1, sysname, c1> <Data_Type_For_Column1, , int>, 
--	<Column_2, sysname, c2> <Data_Type_For_Column2, , int>
--)
--AS
--BEGIN
--	-- Fill the table variable with the rows for your result set
	
--	RETURN 
--END
--GO

CREATE function [dbo].[FindDoctorRelationsss]
(@doctorId int)
returns table
as
return
(
	
/*پیدا کردن رابطه دکتر ها با هم بر اساس فاصله دو دکتر از هم*/
WITH Find_rel(first_doctorId, second_doctor_id, FirstName, SecondName, RelationLevel) 
AS 
(
	SELECT d.doctor_id,d2.doctor_id, d.name, d2.name, 1 AS RelationLevel
	FROM azDB.dbo.Doctor d, azDB.dbo.DoctorsRelations dr, azDB.dbo.Doctor d2
	WHERE d.doctor_id = @doctorId AND dr.doctor1_id = d.doctor_id AND d2.doctor_id = dr.doctor2_id
	
	UNION ALL 

	SELECT d.doctor_id, d2.doctor_id, d.name, d2.name, fr.RelationLevel + 1
	FROM azDB.dbo.Doctor d, azDB.dbo.DoctorsRelations dr, azDB.dbo.Doctor d2, Find_rel fr 
	WHERE d.doctor_id = fr.second_doctor_id AND dr.doctor1_id = d.doctor_id AND d2.doctor_id = dr.doctor2_id
)
SELECT *
FROM Find_rel fr
)
GO
/****** Object:  View [dbo].[View_1]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_1]
AS
SELECT        TOP (100) PERCENT p.name, p.gender, p.age, pc.illness, h.hospitalization_date
FROM            dbo.Hospitalization AS h INNER JOIN
                         dbo.PationtCase AS pc ON h.pationt_id = pc.pationt_id INNER JOIN
                         dbo.Pationt AS p ON pc.national_id = p.national_id
WHERE        (h.acc_clearing_date IS NULL)
ORDER BY pc.entrance_time
GO
/****** Object:  Table [dbo].[Clerk]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clerk](
	[clerk_id] [int] NOT NULL,
	[class] [nvarchar](10) NULL,
 CONSTRAINT [PK_Clerk] PRIMARY KEY CLUSTERED 
(
	[clerk_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliverdPrescription]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliverdPrescription](
	[drugsotre_id] [int] NULL,
	[prescription_id] [int] NULL,
	[date] [date] NULL,
	[end_price] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DoctorWorksHistory]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoctorWorksHistory](
	[doctor_id] [int] NOT NULL,
	[serviceprice_id] [int] NOT NULL,
	[number] [int] NOT NULL,
	[time] [date] NOT NULL,
 CONSTRAINT [PK_DoctorWorksHistory] PRIMARY KEY CLUSTERED 
(
	[doctor_id] ASC,
	[serviceprice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Drug]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drug](
	[drug_id] [int] NOT NULL,
	[name] [nvarchar](50) NULL,
	[expire_time] [date] NULL,
	[creator] [nvarchar](50) NULL,
	[make_time] [date] NULL,
	[price] [float] NOT NULL,
 CONSTRAINT [PK_Drug] PRIMARY KEY CLUSTERED 
(
	[drug_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DrugMaker]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DrugMaker](
	[drug_maker_id] [int] NOT NULL,
	[drugstore_id] [int] NOT NULL,
	[work_shift] [time](7) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DrugStore]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DrugStore](
	[drugstor_id] [int] NOT NULL,
	[boss_id] [int] NULL,
 CONSTRAINT [PK_DrugStore] PRIMARY KEY CLUSTERED 
(
	[drugstor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[employee_id] [int] NOT NULL,
	[hospital_id] [int] NULL,
	[name] [nvarchar](50) NULL,
	[payment] [money] NULL,
	[enter_time] [date] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[employee_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FullTimeDoctor]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FullTimeDoctor](
	[doctor_id] [int] NOT NULL,
	[payment] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Hospital]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hospital](
	[hospital_id] [int] NOT NULL,
	[name] [nvarchar](50) NULL,
	[address] [nvarchar](50) NULL,
 CONSTRAINT [PK_Hospital] PRIMARY KEY CLUSTERED 
(
	[hospital_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Labratory]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Labratory](
	[lab_id] [int] NOT NULL,
	[name] [nvarchar](50) NULL,
	[boss_id] [int] NULL,
 CONSTRAINT [PK_Labratory] PRIMARY KEY CLUSTERED 
(
	[lab_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LabratoryPrescription]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabratoryPrescription](
	[lab_id] [int] NULL,
	[doctor_id] [int] NULL,
	[pationt_id] [int] NULL,
	[fulfilment_date] [date] NULL,
	[delivery_date] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Nurse]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nurse](
	[nurse_id] [int] NOT NULL,
	[shift_work] [time](7) NULL,
	[class] [nvarchar](10) NULL,
 CONSTRAINT [PK_Nurse] PRIMARY KEY CLUSTERED 
(
	[nurse_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OnCallDoctor]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OnCallDoctor](
	[doctor_id] [int] NOT NULL,
	[come_in_number] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Part]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Part](
	[part_id] [int] NOT NULL,
	[hospital_id] [int] NOT NULL,
	[name] [nvarchar](50) NULL,
	[floor] [int] NULL,
 CONSTRAINT [PK_Part] PRIMARY KEY CLUSTERED 
(
	[part_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prescription]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prescription](
	[prescription_id] [int] NOT NULL,
	[doctor_id] [int] NULL,
	[patoint_id] [int] NULL,
	[date] [date] NULL,
 CONSTRAINT [PK_Prescription] PRIMARY KEY CLUSTERED 
(
	[prescription_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrescriptionDrugList]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrescriptionDrugList](
	[prescription_id] [int] NOT NULL,
	[drug_id] [int] NOT NULL,
	[number] [int] NOT NULL,
 CONSTRAINT [PK_PrescriptionDrugList_1] PRIMARY KEY CLUSTERED 
(
	[prescription_id] ASC,
	[drug_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Private]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Private](
	[room_id] [int] NOT NULL,
	[nurse_id] [int] NOT NULL,
 CONSTRAINT [PK_Private] PRIMARY KEY CLUSTERED 
(
	[room_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PublicRoom]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PublicRoom](
	[nurse_id] [int] NOT NULL,
	[room_id] [int] NOT NULL,
 CONSTRAINT [PK_PublicRoom] PRIMARY KEY CLUSTERED 
(
	[nurse_id] ASC,
	[room_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Room]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Room](
	[room_id] [int] NOT NULL,
	[part_id] [int] NOT NULL,
	[price] [money] NULL,
	[bed_number] [int] NULL,
 CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED 
(
	[room_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServicesPrice]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServicesPrice](
	[service_id] [int] NOT NULL,
	[price] [money] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ServicesPrice] PRIMARY KEY CLUSTERED 
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SetAppointment2]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SetAppointment2](
	[doctor_id] [int] NOT NULL,
	[national_id] [int] NOT NULL,
	[clerk_id] [int] NOT NULL,
	[date] [date] NOT NULL,
 CONSTRAINT [PK_SetAppointment2] PRIMARY KEY CLUSTERED 
(
	[doctor_id] ASC,
	[national_id] ASC,
	[date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clerk]  WITH CHECK ADD  CONSTRAINT [FK_Clerk_Employee] FOREIGN KEY([clerk_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Clerk] CHECK CONSTRAINT [FK_Clerk_Employee]
GO
ALTER TABLE [dbo].[DeliverdPrescription]  WITH CHECK ADD  CONSTRAINT [FK_DeliverdPrescription_Prescription] FOREIGN KEY([prescription_id])
REFERENCES [dbo].[Prescription] ([prescription_id])
GO
ALTER TABLE [dbo].[DeliverdPrescription] CHECK CONSTRAINT [FK_DeliverdPrescription_Prescription]
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Doctor_Part] FOREIGN KEY([part_id])
REFERENCES [dbo].[Part] ([part_id])
GO
ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Doctor_Part]
GO
ALTER TABLE [dbo].[DoctorsRelations]  WITH CHECK ADD  CONSTRAINT [FK_DoctorsRelations_Doctor] FOREIGN KEY([doctor1_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[DoctorsRelations] CHECK CONSTRAINT [FK_DoctorsRelations_Doctor]
GO
ALTER TABLE [dbo].[DoctorsRelations]  WITH CHECK ADD  CONSTRAINT [FK_DoctorsRelations_Doctor1] FOREIGN KEY([doctor2_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[DoctorsRelations] CHECK CONSTRAINT [FK_DoctorsRelations_Doctor1]
GO
ALTER TABLE [dbo].[DoctorWorksHistory]  WITH CHECK ADD  CONSTRAINT [FK_DoctorWorksHistory_Doctor] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[DoctorWorksHistory] CHECK CONSTRAINT [FK_DoctorWorksHistory_Doctor]
GO
ALTER TABLE [dbo].[DoctorWorksHistory]  WITH CHECK ADD  CONSTRAINT [FK_DoctorWorksHistory_ServicesPrice] FOREIGN KEY([serviceprice_id])
REFERENCES [dbo].[ServicesPrice] ([service_id])
GO
ALTER TABLE [dbo].[DoctorWorksHistory] CHECK CONSTRAINT [FK_DoctorWorksHistory_ServicesPrice]
GO
ALTER TABLE [dbo].[DrugMaker]  WITH CHECK ADD  CONSTRAINT [FK_DrugMaker_DrugStore] FOREIGN KEY([drugstore_id])
REFERENCES [dbo].[DrugStore] ([drugstor_id])
GO
ALTER TABLE [dbo].[DrugMaker] CHECK CONSTRAINT [FK_DrugMaker_DrugStore]
GO
ALTER TABLE [dbo].[DrugMaker]  WITH CHECK ADD  CONSTRAINT [FK_DrugMaker_Employee] FOREIGN KEY([drug_maker_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[DrugMaker] CHECK CONSTRAINT [FK_DrugMaker_Employee]
GO
ALTER TABLE [dbo].[DrugStore]  WITH CHECK ADD  CONSTRAINT [FK_DrugStore_Employee1] FOREIGN KEY([boss_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[DrugStore] CHECK CONSTRAINT [FK_DrugStore_Employee1]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Hospital] FOREIGN KEY([hospital_id])
REFERENCES [dbo].[Hospital] ([hospital_id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Hospital]
GO
ALTER TABLE [dbo].[FullTimeDoctor]  WITH CHECK ADD  CONSTRAINT [FK_FullTimeDoctor_Doctor] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[FullTimeDoctor] CHECK CONSTRAINT [FK_FullTimeDoctor_Doctor]
GO
ALTER TABLE [dbo].[Hospitalization]  WITH CHECK ADD  CONSTRAINT [FK_Hospitalization_Clerk] FOREIGN KEY([clerk_id])
REFERENCES [dbo].[Clerk] ([clerk_id])
GO
ALTER TABLE [dbo].[Hospitalization] CHECK CONSTRAINT [FK_Hospitalization_Clerk]
GO
ALTER TABLE [dbo].[Hospitalization]  WITH CHECK ADD  CONSTRAINT [FK_Hospitalization_Doctor] FOREIGN KEY([h_doctor_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[Hospitalization] CHECK CONSTRAINT [FK_Hospitalization_Doctor]
GO
ALTER TABLE [dbo].[Hospitalization]  WITH CHECK ADD  CONSTRAINT [FK_Hospitalization_Doctor1] FOREIGN KEY([d_doctor_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[Hospitalization] CHECK CONSTRAINT [FK_Hospitalization_Doctor1]
GO
ALTER TABLE [dbo].[Hospitalization]  WITH CHECK ADD  CONSTRAINT [FK_Hospitalization_Employee] FOREIGN KEY([h_reception_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Hospitalization] CHECK CONSTRAINT [FK_Hospitalization_Employee]
GO
ALTER TABLE [dbo].[Hospitalization]  WITH CHECK ADD  CONSTRAINT [FK_Hospitalization_Employee1] FOREIGN KEY([d_reception_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Hospitalization] CHECK CONSTRAINT [FK_Hospitalization_Employee1]
GO
ALTER TABLE [dbo].[Hospitalization]  WITH CHECK ADD  CONSTRAINT [FK_Hospitalization_PationtCase] FOREIGN KEY([pationt_id])
REFERENCES [dbo].[PationtCase] ([pationt_id])
GO
ALTER TABLE [dbo].[Hospitalization] CHECK CONSTRAINT [FK_Hospitalization_PationtCase]
GO
ALTER TABLE [dbo].[Hospitalization]  WITH CHECK ADD  CONSTRAINT [FK_Hospitalization_Room] FOREIGN KEY([room_id])
REFERENCES [dbo].[Room] ([room_id])
GO
ALTER TABLE [dbo].[Hospitalization] CHECK CONSTRAINT [FK_Hospitalization_Room]
GO
ALTER TABLE [dbo].[Labratory]  WITH CHECK ADD  CONSTRAINT [FK_Labratory_Employee] FOREIGN KEY([boss_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Labratory] CHECK CONSTRAINT [FK_Labratory_Employee]
GO
ALTER TABLE [dbo].[LabratoryPrescription]  WITH CHECK ADD  CONSTRAINT [FK_LabratoryPrescription_Doctor] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[LabratoryPrescription] CHECK CONSTRAINT [FK_LabratoryPrescription_Doctor]
GO
ALTER TABLE [dbo].[LabratoryPrescription]  WITH CHECK ADD  CONSTRAINT [FK_LabratoryPrescription_Labratory] FOREIGN KEY([lab_id])
REFERENCES [dbo].[Labratory] ([lab_id])
GO
ALTER TABLE [dbo].[LabratoryPrescription] CHECK CONSTRAINT [FK_LabratoryPrescription_Labratory]
GO
ALTER TABLE [dbo].[LabratoryPrescription]  WITH CHECK ADD  CONSTRAINT [FK_LabratoryPrescription_PationtCase] FOREIGN KEY([pationt_id])
REFERENCES [dbo].[PationtCase] ([pationt_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LabratoryPrescription] CHECK CONSTRAINT [FK_LabratoryPrescription_PationtCase]
GO
ALTER TABLE [dbo].[Nurse]  WITH CHECK ADD  CONSTRAINT [FK_Nurse_Employee] FOREIGN KEY([nurse_id])
REFERENCES [dbo].[Employee] ([employee_id])
GO
ALTER TABLE [dbo].[Nurse] CHECK CONSTRAINT [FK_Nurse_Employee]
GO
ALTER TABLE [dbo].[OnCallDoctor]  WITH CHECK ADD  CONSTRAINT [FK_OnCallDoctor_Doctor] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[OnCallDoctor] CHECK CONSTRAINT [FK_OnCallDoctor_Doctor]
GO
ALTER TABLE [dbo].[Part]  WITH CHECK ADD  CONSTRAINT [FK_Part_Hospital] FOREIGN KEY([hospital_id])
REFERENCES [dbo].[Hospital] ([hospital_id])
GO
ALTER TABLE [dbo].[Part] CHECK CONSTRAINT [FK_Part_Hospital]
GO
ALTER TABLE [dbo].[PationtCase]  WITH CHECK ADD  CONSTRAINT [FK_PationtCase_Pationt] FOREIGN KEY([national_id])
REFERENCES [dbo].[Pationt] ([national_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PationtCase] CHECK CONSTRAINT [FK_PationtCase_Pationt]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_Doctor] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_Doctor]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_PationtCase] FOREIGN KEY([patoint_id])
REFERENCES [dbo].[PationtCase] ([pationt_id])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_PationtCase]
GO
ALTER TABLE [dbo].[PrescriptionDrugList]  WITH CHECK ADD  CONSTRAINT [FK_PrescriptionDrugList_Drug] FOREIGN KEY([drug_id])
REFERENCES [dbo].[Drug] ([drug_id])
GO
ALTER TABLE [dbo].[PrescriptionDrugList] CHECK CONSTRAINT [FK_PrescriptionDrugList_Drug]
GO
ALTER TABLE [dbo].[PrescriptionDrugList]  WITH CHECK ADD  CONSTRAINT [FK_PrescriptionDrugList_Prescription] FOREIGN KEY([prescription_id])
REFERENCES [dbo].[Prescription] ([prescription_id])
GO
ALTER TABLE [dbo].[PrescriptionDrugList] CHECK CONSTRAINT [FK_PrescriptionDrugList_Prescription]
GO
ALTER TABLE [dbo].[Private]  WITH CHECK ADD  CONSTRAINT [FK_Private_Nurse] FOREIGN KEY([nurse_id])
REFERENCES [dbo].[Nurse] ([nurse_id])
GO
ALTER TABLE [dbo].[Private] CHECK CONSTRAINT [FK_Private_Nurse]
GO
ALTER TABLE [dbo].[Private]  WITH CHECK ADD  CONSTRAINT [FK_Private_Room] FOREIGN KEY([room_id])
REFERENCES [dbo].[Room] ([room_id])
GO
ALTER TABLE [dbo].[Private] CHECK CONSTRAINT [FK_Private_Room]
GO
ALTER TABLE [dbo].[PublicRoom]  WITH CHECK ADD  CONSTRAINT [FK_PublicRoom_Nurse] FOREIGN KEY([nurse_id])
REFERENCES [dbo].[Nurse] ([nurse_id])
GO
ALTER TABLE [dbo].[PublicRoom] CHECK CONSTRAINT [FK_PublicRoom_Nurse]
GO
ALTER TABLE [dbo].[PublicRoom]  WITH CHECK ADD  CONSTRAINT [FK_PublicRoom_Room] FOREIGN KEY([room_id])
REFERENCES [dbo].[Room] ([room_id])
GO
ALTER TABLE [dbo].[PublicRoom] CHECK CONSTRAINT [FK_PublicRoom_Room]
GO
ALTER TABLE [dbo].[Room]  WITH CHECK ADD  CONSTRAINT [FK_Room_Part] FOREIGN KEY([part_id])
REFERENCES [dbo].[Part] ([part_id])
GO
ALTER TABLE [dbo].[Room] CHECK CONSTRAINT [FK_Room_Part]
GO
ALTER TABLE [dbo].[SetAppointment2]  WITH CHECK ADD  CONSTRAINT [FK_SetAppointment2_Clerk] FOREIGN KEY([clerk_id])
REFERENCES [dbo].[Clerk] ([clerk_id])
GO
ALTER TABLE [dbo].[SetAppointment2] CHECK CONSTRAINT [FK_SetAppointment2_Clerk]
GO
ALTER TABLE [dbo].[SetAppointment2]  WITH CHECK ADD  CONSTRAINT [FK_SetAppointment2_Doctor] FOREIGN KEY([doctor_id])
REFERENCES [dbo].[Doctor] ([doctor_id])
GO
ALTER TABLE [dbo].[SetAppointment2] CHECK CONSTRAINT [FK_SetAppointment2_Doctor]
GO
ALTER TABLE [dbo].[SetAppointment2]  WITH CHECK ADD  CONSTRAINT [FK_SetAppointment2_Pationt] FOREIGN KEY([national_id])
REFERENCES [dbo].[Pationt] ([national_id])
GO
ALTER TABLE [dbo].[SetAppointment2] CHECK CONSTRAINT [FK_SetAppointment2_Pationt]
GO
/****** Object:  StoredProcedure [dbo].[calcOnCallDoctorPayment]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO
/*محاسبه حقوق دکتر آن کال*/
CREATE PROCEDURE [dbo].[calcOnCallDoctorPayment]
@doctorId int ,
@startTime date

AS 
	BEGIN
		SELECT SUM(sp.price * dwh.number)
		FROM azDB.dbo.DoctorWorksHistory dwh, azDB.dbo.ServicesPrice sp
		WHERE dwh.doctor_id = @doctorId AND dwh.serviceprice_id = sp.service_id AND dwh.time < DATEADD(MONTH, 1,@startTime) AND dwh.time >= @startTime
	END
GO
/****** Object:  StoredProcedure [dbo].[clerkAddmiter]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO
/*پیدا کردن منشی هایی که حقوقشان از یک مقدار خاص کمتر است وترخیص بستری بیمار را تایید کرده اند*/
CREATE PROCEDURE	[dbo].[clerkAddmiter]
@basePayment float	
AS	
	BEGIN
		SELECT	e.name , e.employee_id
		FROM	azDB.dbo.Employee e	, azDB.dbo.Hospitalization h
		WHERE e.employee_id = h.d_reception_id AND (e.payment < @basePayment OR e.payment IS NULL)
	END
GO
/****** Object:  StoredProcedure [dbo].[DHWLPrescription]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO
/*پیدا کردن دکتر هایی که بالای تعداد خاصی دستور بستری داده اند بدون آنکه تجویز آزمایش انجام داده باشند*/
CREATE	PROCEDURE	[dbo].[DHWLPrescription]
@baseNumber int
AS
	BEGIN
	SELECT *
	FROM (SELECT COUNT(*) OVER(PARTITION BY d.doctor_id)AS doctorCount, d.doctor_id, d.name
			FROM azDB.dbo.Doctor d, azDB.dbo.Hospitalization h
			WHERE h.h_doctor_id = d.doctor_id AND h.pationt_id NOT IN (SELECT lp.pationt_id FROM azDB.dbo.LabratoryPrescription lp )) AS inputDate
	WHERE inputDate.doctorCount > @baseNumber
	END
GO
/****** Object:  StoredProcedure [dbo].[illnessNeedLab]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO
/*پیدا کردن بیماری هایی که به خاطر آنها تجویز آزمایش شده است.*/
CREATE PROCEDURE [dbo].[illnessNeedLab]
AS
	BEGIN
	SELECT pc.illness
	FROM azDB.dbo.LabratoryPrescription lp	, azDB.dbo.PationtCase pc
	WHERE pc.pationt_id = lp.pationt_id
	END
GO
/****** Object:  StoredProcedure [dbo].[LabCauseHospi]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO
/*بدست آوردن آزمایشگاه هایی که باعث بستری شدن بیمار شده اند*/
CREATE PROCEDURE [dbo].[LabCauseHospi]
@minimumNumber int
AS
	BEGIN
	SELECT COUNT(*) AS number, labNames.name
	FROM (SELECT l.name
	FROM dbo.Labratory l, azDB.dbo.LabratoryPrescription lp, azDB.dbo.Hospitalization h
	WHERE lp.lab_id = l.lab_id AND h.pationt_id = lp.pationt_id) AS labNames
	GROUP BY labNames.name
	HAVING COUNT(*) > @minimumNumber
	END
	 
GO
/****** Object:  StoredProcedure [dbo].[LongestHospitalization]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO
/*بیشترین زمان بستری بودن هر بیمار*/
CREATE	PROCEDURE [dbo].[LongestHospitalization]
AS
	BEGIN	
		SELECT DISTINCT MAX(DATEDIFF(DAY , h.hospitalization_date ,h.acc_clearing_date))OVER(PARTITION	BY pc.pationt_id ) AS numOfDays, p.name, pc.pationt_id
		FROM azDB.dbo.PationtCase pc,  azDB.dbo.Hospitalization h, azDB.dbo.Pationt p
		WHERE pc.pationt_id = h.pationt_id AND p.national_id=pc.national_id AND h.acc_clearing_date IS NOT NULL
	END	

GO
/****** Object:  StoredProcedure [dbo].[pationPrescriptionHistory]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO
/*تاریخجه نسخه های تحویل داده شده به بیمار*/
CREATE	PROCEDURE [dbo].[pationPrescriptionHistory]
@national_id int
AS 
	BEGIN	
		SELECT	*
		FROM	azDB.dbo.Prescription p, azDB.dbo.DeliverdPrescription dp, azDB.dbo.PationtCase pc
		WHERE p.patoint_id = pc.pationt_id AND p.prescription_id = dp.prescription_id AND pc.national_id = @national_id
		ORDER BY p.[date]
	END
GO
/****** Object:  StoredProcedure [dbo].[returnHistory]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- ================================================
---- Template generated from Template Explorer using:
---- Create Procedure (New Menu).SQL
----
---- Use the Specify Values for Template Parameters 
---- command (Ctrl-Shift-M) to fill in the parameter 
---- values below.
----
---- This block of comments will not be included in
---- the definition of the procedure.
---- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO


/*تاریخچه بیمار های بستری شده در بیمارستان*/
CREATE	PROCEDURE	[dbo].[returnHistory]
@age [int]
AS
	BEGIN	
		SELECT	*
		FROM	azDB.dbo.Pationt p , azDB.dbo.PationtCase pc
		WHERE	p.age > @age AND p.national_id = pc.national_id	
		ORDER BY p.age
	END
GO
/****** Object:  StoredProcedure [dbo].[RoomPationtNumber]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO
/*تعداد بیمار های هر اتاق*/
CREATE	PROCEDURE	[dbo].[RoomPationtNumber]
@startTime date
AS
	BEGIN	
		SELECT	distinct COUNT(*) OVER	(PARTITION BY r.room_id) AS number, r.room_id
		FROM azDB.dbo.Room r, azDB.dbo.Hospitalization h
		WHERE	r.room_id = h.room_id AND h.hospitalization_date > @startTime
	END
GO
/****** Object:  StoredProcedure [dbo].[worstIllness]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
--CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
--	-- Add the parameters for the stored procedure here
--	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
--	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
--END
--GO

/*بیشترین بیماری یک ماه اخیر*/
CREATE	PROCEDURE [dbo].[worstIllness]
@startTIme date
AS
	BEGIN	
		SELECT	MAX(illnessCount.pa), illnessCount.illness
		FROM
		(SELECT	COUNT(*)OVER(PARTITION	BY	pc.illness) AS pa, pc.illness AS illness
		FROM	azDB.dbo.Hospitalization h	, azDB.dbo.PationtCase pc
		WHERE h.pationt_id = pc.pationt_id AND h.hospitalization_date	> @startTime) AS illnessCount
		GROUP BY illnessCount.illness
	END
GO
/****** Object:  DdlTrigger [DDL_Trigger0]    Script Date: 1/28/2020 7:20:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================
--  Create database trigger template 
--====================================
--USE <database_name, sysname, AdventureWorks>
--GO

--IF EXISTS(
--  SELECT *
--    FROM sys.triggers
--   WHERE name = N'<trigger_name, sysname, table_alter_drop_safety>'
--     AND parent_class_desc = N'DATABASE'
--)
--	DROP TRIGGER <trigger_name, sysname, table_alter_drop_safety> ON DATABASE
--GO

--CREATE TRIGGER <trigger_name, sysname, table_alter_drop_safety> ON DATABASE 
--	FOR <data_definition_statements, , DROP_TABLE, ALTER_TABLE> 
--AS 
--IF IS_MEMBER ('db_owner') = 0
--BEGIN
--   PRINT 'You must ask your DBA to drop or alter tables!' 
--   ROLLBACK TRANSACTION
--END
--GO

CREATE TRIGGER [DDL_Trigger0]
ON DATABASE
FOR DROP_TABLE
AS 
	print N' نمیتونی!!!!'
	ROLLBACK
GO
ENABLE TRIGGER [DDL_Trigger0] ON DATABASE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "h"
            Begin Extent = 
               Top = 6
               Left = 592
               Bottom = 136
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "pc"
            Begin Extent = 
               Top = 8
               Left = 384
               Bottom = 138
               Right = 554
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "h"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "pc"
            Begin Extent = 
               Top = 6
               Left = 270
               Bottom = 136
               Right = 440
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 478
               Bottom = 136
               Right = 648
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_2'
GO
