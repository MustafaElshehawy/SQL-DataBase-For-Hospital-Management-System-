--إضافة موعد جديد مع التحقق من الطبيب والمريض
--لا يسمح بإضافة موعد إذا الطبيب غير موجود أو المريض غير موجود

--الاكيد هنستخدم StoredProcedure 
--لو في تعديل بيانات / منطق معقّد / أكثر من خطوة <- Procedure لان منطق
--اختيار الانسب لقواعد  والتتحقق من البيانات قبل الإدخال

create Proc ADDAppointment 
	@PatientId Int,
	@DoctorId INT,
	@AppointmentDate DATE
AS
BEGIN
	IF NOT EXISTS  (SELECT 1 FROM Patients WHERE patient_id =@PatientId)
	BEGIN
		RAISERROR('Patient does not exist',16,1)
		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM Doctors WHERE doctor_id =@DoctorId)
	BEGIN
		RAISERROR('Doctor does not exist',16,1)
		RETURN
	END

	INSERT INTO Apointments(patient_id,doctor_id,appointment_date,status)
	VALUES(@PatientId,@DoctorId,@AppointmentDate,'Pending')
END

---call
EXEC ADDAppointment 1,2,'2026-01-10'


---2-إنهاء موعد وإنشاء فاتورة تلقائية 
--لما الموعد يخلص  تتحول لي complate
--والفاتورة تتنشأ تلقائياا

CREATE PROCEDURE CompleteAppointment
	@AppointmentId INT,
	@TotalAmount DECIMAL(10,2)
AS
BEGIN
	BEGIN TRANSACTION 
	--تتم كحزمة واحدة 
	--فهي تضمن أنه إذا فشلت الخطوة الثانية، يتم إلغاء الخطوة الأولى تلقائياً. 
		UPDATE Apointments
		SET status='Completed'
		WHERE apointment_id=@AppointmentId

		INSERT INTO Bills
		(apointment_id,total_amount,payment_status,bill_date)
		VALUES
		(@AppointmentId,@TotalAmount,'Unpaid',GETDATE())
	COMMIT TRANSACTION
END

--call

EXEC CompleteAppointment 15,30000


--Function تستخدم للحسابات المتكررة بدون تعديل بيانات.

--حساب عمر المريض
CREATE FUNCTION dbo.CalcPatientAge(@BirthDate Date)
Returns INT
AS
BEGIN
	Return DATEDIFF(YEAR,@BirthDate, GETDATE())
END

--use 
--function used inside query statement
SELECT name, dbo.CalcPatientAge(birth_date) AS Age
FROM Patients

--حساب عدد مواعيد الطبيب (Scalar Function)
--لان اللي راجع قيمة واحده 
CREATE FUNCTION dbo.DoctorAppointmentCount(@DoctorId INT)
RETURNS INT
AS
BEGIN
	DECLARE @Count INT
	SELECT @Count=Count(*) FROM Apointments WHERE doctor_id=@DoctorId
	RETURN @Count
END
--use
SELECT name,
       dbo.DoctorAppointmentCount(doctor_id) AS TotalAppointments
FROM Doctors;
