
INSERT INTO Departments
	(department_name)
VALUES
	('Internal Medicine'),
	('General Surgery'),
	('Emergency Medicine');

INSERT INTO Doctors
	(name,specialty,department_id)
VAlUES
	('Dr. Ahmad Mansour', 'Cardiologist', 1),--أخصائي أمراض القلب
    ('Dr. Sarah Khalil', 'Endocrinologist', 1),--أخصائية الغدد الصماء
	('Dr. Omar Faisal', 'Neurosurgeon', 2),--جراح الأعصاب
    ('Dr. Laila Hassan', 'Orthopedic Surgeon', 2),--جراحة العظام
	('Dr. Khaled Zaid', 'Trauma Specialist', 3),--أخصائي الإصابات
    ('Dr. Mona Sami', 'Critical Care Specialist', 3);--أخصائية العناية المركزة

--to set forget values of salary can try to update
--update one Row 
update Doctors
SET salary=3000.33 
WHERE doctor_id =1
--update muilt ros with defferant values
UPDATE DOCTORS
SET salary = case
	WHEN doctor_id=1 THEN 6000.30
	WHEN doctor_id=2 THEN 2000.2
	WHEN doctor_id=3 THEN 1500.4
	WHEN doctor_id=4 THEN 2500
	WHEN doctor_id=5 THEN 700
	WHEN doctor_id=6 THEN 700
	ELSE doctor_id
END
WHERE doctor_id IN(1,2,3,4,5,6)

INSERT INTO Patients
	(name,gender,birth_date,phone,city)
VALUES
	('Ali mohamed','male','2000-02-22','0123456789','Alex'),
	('aya ALi','female','1980-01-10','0123456789','cairo'),
	('omer mohamed','male','2005-01-10','0123456789','mansoura');

INSERT INTO Apointments
	(patient_id,doctor_id,appointment_date,status)
VAlues
	( 1, 1, '2026-01-05', 'Pending'),
	( 2, 2, '2026-01-03', 'Completed'),
	( 3, 3, '2026-01-04', 'Canceled');


INSERT INTO Bills
	(apointment_id,total_amount,payment_status,bill_date)
VALUES
	(15,300,'Unpaid','2026-01-05'),
	(16,850,'paid','2026-01-03');
