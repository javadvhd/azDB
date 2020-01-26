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

CREATE TRIGGER CheckLowLimitForInsurance ON Hospitalization
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
