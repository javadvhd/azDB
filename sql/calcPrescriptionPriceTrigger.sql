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


/*تریگر واسه اضافه کردن نسخه های تحویل داده شده برای محاسبه جمع قیمت دارو های آن*/
CREATE TRIGGER calc_price_for_prescription ON DeliverdPrescription
INSTEAD OF INSERT
AS 
	DECLARE @prescriptionId int, @drugstoreid int , @someofprice float
	SELECT @prescriptionId = prescription_id FROM inserted
	SELECT @drugstoreid = drugsotre_id FROM inserted

	BEGIN 
	SET @someofprice =( select SUM(d.price * pdl.number)
	FROM azDB.dbo.Drug d, azDB.dbo.PrescriptionDrugList pdl
	WHERE pdl.prescription_id = @prescriptionId and d.drug_id = pdl.drug_id)

	insert into azDB.dbo.DeliverdPrescription values(@drugstoreid, @prescriptionId, 'today', @someofprice)
	END
GO
