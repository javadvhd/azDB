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
CREATE TRIGGER CheckLowLimitForHospita ON azDB.dbo.Hospitalization
INSTEAD OF INSERT
AS 
DECLARE @nationalId int
	SELECT @nationalId = pc.national_id	
	FROM inserted, azDB.dbo.PationtCase pc
	WHERE pc.pationt_id = inserted.pationt_id

BEGIN 
	if((SELECT COUNT(*)
		FROM azDB.dbo.Hospitalization h, azDB.dbo.PationtCase pc
		WHERE h.pationt_id = pc.pationt_id AND pc.national_id=@nationalId)>4)
		BEGIN
			PRINT N'حداکثر تعداد محاز برای بستری این بیمار لحاظ شده است'
			ROLLBACK
		END
END