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

CREATE TRIGGER check_PR_consistancy ON azDB.dbo.PublicRoom
INSTEAD OF INSERT
AS
DECLARE @room_id int
DECLARE @nurse_id int
	SELECT	@room_id=INSERTED.room_id FROM inserted
	SELECT @nurse_id = INSERTED.nurse_id FROM INSERTED 
BEGIN 
	IF(@room_id NOT IN (SELECT p.room_id FROM dbo.Private p))
	BEGIN
		insert INTO azDB.dbo.PublicRoom
		(
		    nurse_id,
		    room_id
		)
		VALUES
		(
		    @nurse_id, -- nurse_id - int
		    @room_id -- room_id - int
		)
	END
	else
	BEGIN
	PRINT	N'اتاق با این آی دی به عنوان اتاق خصوصی تعریف شده است'

	END
END

