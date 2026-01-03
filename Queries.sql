--عرض كل المرضى في مدينة معينة
SELECT * FROM Patients WHERE city ='cairo'

-- عرض الاطباء حسب تخصص معين وبراتب
SELECT* FROM Doctors WHERE specialty ='Cardiologist' AND salary IS NOT NULL

--عرض المواعيد القادمة فقط
SELECT* FROM Apointments WHERE appointment_date >= CAST(GETDATE()AS DATE)

--اسم المريض واسم الطبيب وتاريخ الموعد 
SELECT p.name AS patient_name,d.name AS doctor_name,a.appointment_date
FROM Apointments a
JOIN  Patients p ON p.patient_id = a.patient_id 
JOIN Doctors d ON d.doctor_id =a.doctor_id

--عرض الأطباء مع أسماء الأقسام التابعة لهم
SELECT  doc.name AS doctor_name,dep.department_name
FROM Doctors doc
JOIN Departments dep ON doc.department_id = dep.department_id

--عدد المرضى في كل مدينة
SELECT COUNT(name) AS number_of_patient,city FROM Patients GROUP BY city

--إجمالي الدخل لكل قسم 
SELECT Dep.department_name,SUM(B.total_amount)AS total_price
FROM Bills B
JOIN Apointments A ON B.apointment_id = A.apointment_id
Join Doctors Doc ON A.doctor_id = Doc.doctor_id
JOIN Departments Dep ON Doc.department_id =Dep.department_id
WHERE B.payment_status='Paid'
GROUP BY Dep.department_name

--متوسط راتب الأطباء
SELECT AVG(salary)AS AvgSalary FROM Doctors

--الأطباء اللي عندهم مواعيد
SELECT D.name,A.appointment_date
FROM Apointments A
Join Doctors D ON D.doctor_id=A.doctor_id

--OR
SELECT name FROM Doctors WHERE doctor_id IN (SELECT DISTINCT doctor_id FROM Apointments )

--المرضى اللي ماعملوش أي موعد
SELECT * FROM Patients WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM Apointments)

--أغلى فاتورة في المستشفى
SELECT * FROM Bills WHERE bill_id =(SELECT Max(total_amount) FROM Bills)

--أكثر طبيب لديه مواعيد
SELECT Top 1 doctor_id ,count(appointment_date) AS total_date FROM Apointments GROUP BY doctor_id  ORDER BY total_date

--الأقسام اللي مافيهاش أطباء
SELECT *
FROM Departments 
WHERE department_id NOT IN (SELECT department_id FROM Doctors)
