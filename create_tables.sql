CREATE DATABASE Hospital_Management_System
use Hospital_Management_System


CREATE TABLE Departments
(
	department_id INT IDENTITY PRIMARY KEY,
	department_name VARCHAR(50) NOT NULL,

)

CREATE TABLE Doctors
(
	doctor_id INT IDENTITY PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	specialty VARCHAR(50),
	salary DECIMAL(10,2),
	department_id INT,
	CONSTRAINT FK_DEPERTMENT_ID FOREIGN KEY (department_id) REFERENCES Departments(department_id)

)

CREATE TABLE Patients
(
	patient_id INT IDENTITY PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	gender VARCHAR(10),
	birth_date DATE,
	phone VARCHAR(15),
	city VARCHAR(50),
	CONSTRAINT check_gender CHECK(gender IN ('male','female')),
)

CREATE TABLE Apointments
(
	apointment_id INT IDENTITY PRIMARY KEY,
	patient_id INT,
	doctor_id INT,
	appointment_date DATE,
	status VARCHAR(20),
	CONSTRAINT FK_PATIANT_ID FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
	CONSTRAINT FK_DOCTOR_ID FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
	CONSTRAINT check_status CHECK(status IN('Completed '' Canceled '' Pending'))
)

--edit constraint check_stats  -must drop and then add again
ALTER TABLE Apointments
DROP CONSTRAINT check_status

AlTER TABLE Apointments
ADD CONSTRAINT check_status CHECK(status IN('Completed','Canceled','Pending'))


CREATE TABLE Bills
(
	bill_id INT IDENTITY PRIMARY KEY,
	apointment_id INT,
	total_amount DECIMAL (10,2),
	payment_status VARCHAR(20),
	bill_date DATE
	CONSTRAINT FK_APOINTMENT_ID FOREIGN KEY (apointment_id ) REFERENCES Apointments(apointment_id),
	CONSTRAINT check_payment_status CHECK(payment_status IN ('Paid','Unpaid'))

)