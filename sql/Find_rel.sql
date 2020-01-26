
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