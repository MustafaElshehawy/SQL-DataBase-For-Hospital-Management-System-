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