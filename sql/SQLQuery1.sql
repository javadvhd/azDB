--/*تاریخچه بیمار های بستری شده در بیمارستان*/
--CREATE	PROCEDURE	dbo.Pationt
--@age [int]
--AS
--	BEGIN	
--		SELECT	*
--		FROM	azDB.dbo.Pationt p , azDB.dbo.PationtCase pc
--		WHERE	p.age > @age AND p.national_id = pc.national_id	
--		ORDER BY p.age
--	END
--/*تاریخجه نسخه های تحویل داده شده به بیمار*/
--CREATE	PROCEDURE dbo.Prescription
--@national_id int
--AS 
--	BEGIN	
--		SELECT	*
--		FROM	azDB.dbo.Prescription p, azDB.dbo.DeliverdPrescription dp, azDB.dbo.PationtCase pc
--		WHERE p.patoint_id = pc.pationt_id AND p.prescription_id = dp.prescription_id AND pc.national_id = @national_id
--		ORDER BY p.[date]
--	END

--/*محاسبه حقوق دکتر آن کال*/
--CREATE PROCEDURE dbo.Doctor
--@doctorId int ,
--@startTime date

--AS 
--	BEGIN
--		SELECT SUM(sp.price * dwh.number)
--		FROM azDB.dbo.DoctorWorksHistory dwh, azDB.dbo.ServicesPrice sp
--		WHERE dwh.doctor_id = @doctorId AND dwh.serviceprice_id = sp.service_id AND dwh.time < @startTime + 1
--	END

--/*بیشترین زمان بستری بودن هر بیمار*/
--CREATE	PROCEDURE dbo.Pationt	
--AS
--	BEGIN	
--		SELECT MAX(h.acc_clearing_date - h.hospitalization_date)OVER(PARTITION	BY pc.national_id )
--		FROM azDB.dbo.PationtCase pc,  azDB.dbo.Hospitalization h
--		WHERE pc.pationt_id = h.pationt_id
--	END	


--/*تعداد بیمار های هر اتاق*/
--CREATE	PROCEDURE	dbo.Room
--@startTime date
--AS
--	BEGIN	
--		SELECT	COUNT(*) OVER	(PARTITION BY r.room_id)
--		FROM azDB.dbo.Room r, azDB.dbo.Hospitalization h
--		WHERE	r.room_id = h.room_id AND h.hospitalization_date > @startTime
--	END

--/*بیشترین بیماری یک ماه اخیر*/
--CREATE	PROCEDURE dbo.Pationt
--@startTIme date
--AS
--	BEGIN	
--		SELECT	MAX(illnessCount.pa), illnessCount.illness
--		FROM
--		(SELECT	COUNT(*)OVER(PARTITION	BY	pc.illness) AS pa, pc.illness AS illness
--		FROM	azDB.dbo.Hospitalization h	, azDB.dbo.PationtCase pc
--		WHERE h.pationt_id = pc.pationt_id AND h.hospitalization_id	> @startTime) AS illnessCount
--	END


--/*پیدا کردن منشی هایی که حقوقشان از یک مقدار خاص کمتر است و بستری بیمار را تایید کرده اند*/
--CREATE PROCEDURE	dbo.Employee
--@basePayment float	
--AS	
--	BEGIN
--		SELECT	e.name , e.employee_id
--		FROM	azDB.dbo.Employee e	, azDB.dbo.Hospitalization h
--		WHERE e.employee_id = h.h_reception_id AND e.payment < @basePayment 
--	END


--/*پیدا کردن دکتر هایی که بالای تعداد خاصی دستور بستری داده اند بدون آنکه تجویز آزمایش انجام داده باشند.*/
--CREATE	PROCEDURE	dbo.Doctor
--@baseNumber int
--AS
--	BEGIN
--	SELECT DISTINCT *
--	FROM (SELECT COUNT(*) OVER(PARTITION BY d.doctor_id)AS doctorCount, d.doctor_id, d.name
--			FROM azDB.dbo.Doctor d, azDB.dbo.Hospitalization h, azDB.dbo.PationtCase pc
--			WHERE h.h_doctor_id = d.doctor_id AND h.pationt_id NOT IN (SELECT lp.pationt_id FROM azDB.dbo.LabratoryPrescription lp ) AS inputDate
--	WHERE inputDate.doctorCount > @baseNumber
--	END

--/*پیدا کردن بیماری هایی که به خاطر آنها تجویز آزمایش شده است.*/
--CREATE PROCEDURE dbo.LabratoryPrescription
--AS
--	BEGIN
--	SELECT pc.illness
--	FROM azDB.dbo.LabratoryPrescription lp	, azDB.dbo.PationtCase pc
--	WHERE pc.pationt_id = lp.pationt_id
--	END


--/*بدست آوردن آزمایشگاه هایی که باعث بستری شدن بیمار شده اند*/
--CREATE PROCEDURE dbo.Labratory
--@minimumNumber int
--AS
--	BEGIN
--	SELECT COUNT(*), labNames.name
--	FROM (SELECT l.name
--	FROM dbo.Labratory l, azDB.dbo.LabratoryPrescription lp, azDB.dbo.Hospitalization h
--	WHERE lp.lab_id = l.lab_id AND h.pationt_id = lp.pationt_id) AS labNames
--	GROUP BY labNames.name
--	HAVING COUNT(*) > @minimumNumber
--	END
	 


--/*محاسبه قیمت داروهای تحویل داده شده توسط داروخانه اعلامی*/
--CREATE FUNCTION	all_income(@drugStoreId int)
--RETURNS	float
--AS 
--BEGIN	
--	RETURN	(SELECT	SUM(dp.end_price)
--	FROM	azDB.dbo.DeliverdPrescription dp
--	WHERE	dp.drugsotre_id = @drugStoreId)
--END;

/*تریگر واسه اضافه کردن نسخه های تحویل داده شده برای محاسبه جمع قیمت دارو های آن*/
--CREATE TRIGGER calc_price_for_prescription ON azDB.dbo.DeliverdPrescription
--INSTEAD OF INSERT
--AS 
--	DECLARE @prescriptionId int, @drugstoreid int , @someofprice float
--	SELECT @prescriptionId = prescription_id FROM inserted
--	SELECT @drugstoreid = drugsotre_id FROM inserted

--	BEGIN 
--	SET @someofprice =( select SUM(d.price * pdl.number)
--	FROM azDB.dbo.Drug d, azDB.dbo.PrescriptionDrugList pdl
--	WHERE pdl.prescription_id = @prescriptionId and d.drug_id = pdl.drug_id)

--	insert into azDB.dbo.DeliverdPrescription values(@drugstoreid, @prescriptionId, 'today', @someofprice)
--	END
--GO

--/*ddl trigger*/
--CREATE TRIGGER DDL_Trigger0
--ON DATABASE
--FOR DROP_TABLE
--AS 
--	print N' نمیتونی!!!!'
--	ROLLBACK
--GO
/*مشاهده بیماران در حال بستری*/
--CREATE VIEW liveScore(Name, Gender, Age, Illness, Entrance)
--AS 
--	SELECT p.name , p.gender, p.age, pc.illness, pc.entrance_time
--	FROM  azDB.dbo.Hospitalization h, azDB.dbo.PationtCase pc, azDB.dbo.Pationt p
--	WHERE pc.pationt_id = h.pationt_id AND h.acc_clearing_date = NULL AND p.national_id = pc.national_id
--	ORDER BY pc.entrance_time
--END

/*پیدا کردن رابطه دکتر ها با هم بر اساس فاصله دو دکتر از هم*/
WITH Find_rel(doctor_id, FirstName, SecondName, RelationLevel)
AS 
(
	SELECT d.doctor_id, d.name, d2.name, 1 AS RelationLevel
	FROM azDB.dbo.Doctor d, azDB.dbo.DoctorsRelations dr, azDB.dbo.Doctor d2
	WHERE d.doctor_id = 1 AND dr.doctor1_id = d.doctor_id AND d2.doctor_id = dr.doctor2_id
	
	UNION ALL 

	SELECT d.doctor_id, d.name, d2.name, fr.RelationLevel + 1
	FROM azDB.dbo.Doctor d, azDB.dbo.DoctorsRelations dr, azDB.dbo.Doctor d2, Find_rel fr 
	WHERE d.doctor_id = fr.doctor_id AND dr.doctor1_id = d.doctor_id AND d2.doctor_id = dr.doctor2_id
)
SELECT *
FROM Find_rel fr
/*جلوگیری از بستری شدن زیاد یک بیمار*/
--CREATE TRIGGER CheckLowLimitForInsurance ON Hospitalization
--INSTEAD OF INSERT
--AS 
--DECLARE @nationalId int
--	SELECT @nationalId = pc.national_id	
--	FROM inserted, azDB.dbo.PationtCase pc
--	WHERE pc.pationt_id = inserted.pationt_id

--BEGIN 
--	if((SELECT COUNT(*)
--		FROM azDB.dbo.Hospitalization h, azDB.dbo.PationtCase pc
--		WHERE h.pationt_id = pc.pationt_id AND pc.national_id=@nationalId)>4)
--		BEGIN
--			PRINT N'حداکثر تعداد محاز برای بستری این بیمار لحاظ شده است'
--			ROLLBACK
--		END
--END