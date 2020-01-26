-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
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
--CREATE TRIGGER <Schema_Name, sysname, Schema_Name>.<Trigger_Name, sysname, Trigger_Name> 
--   ON  <Schema_Name, sysname, Schema_Name>.<Table_Name, sysname, Table_Name> 
--   AFTER <Data_Modification_Statements, , INSERT,DELETE,UPDATE>
--AS 
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for trigger here

--END
--GO
CREATE TRIGGER	check_consistancy_for_OCD ON azDB.dbo.OnCallDoctor
INSTEAD	OF INSERT
AS
DECLARE @DocId int
DECLARE @comein float
	SELECT @DocId=i.doctor_id FROM INSERTED i
	SELECT @comein= i.come_in_number FROM INSERTED i
BEGIN
	IF(@DocId NOT IN	(SELECT 	ftd.doctor_id
						FROM  azDB.dbo.FullTimeDoctor ftd ))
		BEGIN
		INSERT INTO	dbo.OnCallDoctor
		(
		    doctor_id,
		    come_in_number
		)
		VALUES
		(
		    @DocId, -- doctor_id - int
		    @comein -- come_in_number - int
		)
		END
	else
	BEGIN
		PRINT	N'دکتر با این آی دی در دکتر های تمام وقت وجود دارد'
	END
END