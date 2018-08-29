--*************************************************************************--
-- Title: Info340 Final Project
-- Author: ByungSuJung
-- Desc: This file is used to create a database for the Final
-- Change Log: When,Who,What
-- 2017-01-01,ByungSuJung,Created File
--**************************************************************************--
-- Step 1: Create the Lab database
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'MyFinalDB_ByungSuJung')
 Begin 
  Alter Database [MyFinalDB_ByungSuJung] set Single_user With Rollback Immediate;
  Drop Database MyFinalDB_ByungSuJung;
 End
go

Create Database MyFinalDB_ByungSuJung;
go
Use MyFinalDB_ByungSuJung;
go

-- 1) Create the tables --------------------------------------------------------
-- Clinics --
Create 
Table Clinics(
	ClinicID int Identity(1,1) Not Null,
	ClinicName nVarchar(100) Not Null,
	ClinicPhoneNumber nVarchar(100)	Not Null,
	ClinicAddress nVarchar(100)	Not Null,
	ClinicCity nVarchar(100) Not Null,
	ClinicState	nChar(2) Not Null,
	ClinicZip nVarchar(10) Not Null

	Constraint pkClinics Primary Key Clustered(
		ClinicID
	)
);
Go

-- Patients --
Create 
Table Patients(
	PatientID int Identity(1,1) Not Null,
	PatientFirstName nVarchar(100) Not Null,
	PatientLastName	nVarchar(100) Not Null,
	PatientPhoneNumber nVarchar(100) Not Null,
	PatientAddress nVarchar(100) Not Null,
	PatientCity	nVarchar(100) Not Null,
	PatientState nChar(2) Not Null,
	PatientZip nVarchar(10) Not Null

	Constraint pkPatients Primary Key Clustered(
		PatientID
	)
);
Go

-- Doctors --

Create 
Table Doctors(
	DoctorID int Identity(1,1) Not Null,
	DoctorFirstName	nVarchar(100) Not Null,
	DoctorLastName nVarchar(100) Not Null,
	DoctorPhoneNumber nVarchar(100) Not Null,
	DoctorAddress nVarchar(100) Not Null,
	DoctorCity nVarchar(100) Not Null,
	DoctorState	nChar(2) Not Null,
	DoctorZip nVarchar(10) Not Null

	Constraint pkDoctors Primary Key Clustered(
		DoctorID
	)
);
Go

-- Appointments --

Create
Table Appointments(
	AppointmentID int Identity(1,1) Not Null,
	AppointmentDate	date Not Null,
	AppointmentTime time Not Null,
	AppointmentPatientID int Not Null,
	AppointmentDoctorID	int Not Null,
	AppointmentClinicID	int Not Null

	Constraint pkAppointments Primary Key Clustered(
		AppointmentID
	)
);
Go

-- 2) Create the constraints ---------------------------------------------------

-- Clinics --
Begin

Alter Table Clinics
	Add Constraint ukClinicName Unique (
		ClinicName
	);
Alter Table Clinics
	Add Constraint ckClinicPhoneNumber Check (
		ClinicPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
	);
Alter Table Clinics
	Add Constraint ckClinicZip Check (
		ClinicZip like ('[0-9][0-9][0-9][0-9][0-9]')
		or ClinicZip like ('[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
	);

End
Go

-- Patients -- 
Begin

Alter Table Patients
	Add Constraint ckPatientPhoneNumber Check (
		PatientPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
	);
Alter Table Patients
	Add Constraint ckPatientZip Check (
		PatientZip like ('[0-9][0-9][0-9][0-9][0-9]')
		or PatientZip like ('[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
	);

End
Go

-- Doctors --
Begin

Alter Table Doctors
	Add Constraint ckDoctorPhoneNumber Check (
		DoctorPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
	);
Alter Table Doctors
	Add Constraint ckDoctorZip Check (
		DoctorZip like ('[0-9][0-9][0-9][0-9][0-9]')
		or DoctorZip like ('[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
	);

End
Go

-- Appointments --
Begin

Alter Table Appointments
	Add Constraint fkAppointments_Patients Foreign Key(
		AppointmentPatientID
	) References Patients (
		PatientID
	);
Alter Table Appointments
	Add Constraint fkAppointments_Doctors Foreign Key(
		AppointmentDoctorID
	) References Doctors (
		DoctorID
	);
Alter Table Appointments
	Add Constraint fkAppointments_Clinics Foreign Key(
		AppointmentClinicID
	) References Clinics (
		ClinicID
	);
Alter Table Appointments
	Add Constraint ckAppointmentDateGreaterThanEqualToToday Check(
		(Cast(AppointmentDate As Datetime) +  Cast(AppointmentTime As Datetime))>= getdate()
	);

End
Go
-- 3) Create the views ---------------------------------------------------------

-- Clinics --
Create View vClinics
As
Select 
	ClinicID,
	ClinicName,
	ClinicPhoneNumber,
	ClinicAddress,
	ClinicCity,
	ClinicState,
	ClinicZip
From Clinics;
Go

-- Patients --
Create View vPatients
As
Select
	PatientID,
	PatientFirstName,
	PatientLastName,
	PatientPhoneNumber,
	PatientAddress,
	PatientCity,
	PatientState,
	PatientZip
From Patients;
Go

-- Doctors --
Create View vDoctors
As
Select
	DoctorID,
	DoctorFirstName,
	DoctorLastName,
	DoctorPhoneNumber,
	DoctorAddress,
	DoctorCity,
	DoctorState,
	DoctorZip
From Doctors;
Go

-- Appointments --
Create View vAppointments
As
Select
	AppointmentID,
	AppointmentDate,
	AppointmentTime,
	AppointmentPatientID,
	AppointmentDoctorID,
	AppointmentClinicID
From Appointments;
Go

-- vClinicPatientDoctorAppointment --
Create View vClinicPatientDoctorAppointment
As
Select
	c.ClinicID,
	c.ClinicName,
	c.ClinicPhoneNumber,
	c.ClinicAddress,
	c.ClinicCity,
	c.ClinicState,
	c.ClinicZip,
	p.PatientID,
	p.PatientFirstName,
	p.PatientLastName,
	p.PatientPhoneNumber,
	p.PatientAddress,
	p.PatientCity,
	p.PatientState,
	p.PatientZip,
	d.DoctorID,
	d.DoctorFirstName,
	d.DoctorLastName,
	d.DoctorPhoneNumber,
	d.DoctorAddress,
	d.DoctorCity,
	d.DoctorState,
	d.DoctorZip,
	a.AppointmentID,
	a.AppointmentDate,
	a.AppointmentTime,
	a.AppointmentPatientID,
	a.AppointmentDoctorID,
	a.AppointmentClinicID
From Appointments as a
Join Clinics as c
On a.AppointmentClinicID = c.ClinicID
Join Patients as p
On a.AppointmentPatientID = p.PatientID
Join Doctors as d
on a.AppointmentDoctorID = d.DoctorID;
Go

-- 4) Create the stored procedures ---------------------------------------------

-- Inserts --
Create Procedure pInsClinics
(@ClinicID int Output,
 @ClinicName nVarchar(100),
 @ClinicPhoneNumber nVarchar(100),
 @ClinicAddress nVarchar(100),
 @ClinicCity nVarchar(100),
 @ClinicState	nChar(2),
 @ClinicZip nVarchar(10)
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which inserts data into Clinics table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into Clinics
	(ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZip)
	Values
	(@ClinicName, @ClinicPhoneNumber, @ClinicAddress, @ClinicCity, @ClinicState, @ClinicZip)
	Set @ClinicID = @@Identity;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsPatients
(@PatientID int Output,
 @PatientFirstName nVarchar(100),
 @PatientLastName nVarchar(100),
 @PatientPhoneNumber nVarchar(100),
 @PatientAddress nVarchar(100),
 @PatientCity nVarchar(100),
 @PatientState nChar(2),
 @PatientZip nVarchar(10)
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which inserts data into Patients table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into Patients
	(PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZip)
	Values
	(@PatientFirstName, @PatientLastName, @PatientPhoneNumber, @PatientAddress, @PatientCity, @PatientState, @PatientZip)
    Set @PatientID = @@Identity;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsDoctors
(@DoctorID int Output,
 @DoctorFirstName nVarchar(100),
 @DoctorLastName nVarchar(100),
 @DoctorPhoneNumber	nVarchar(100),
 @DoctorAddress	nVarchar(100),
 @DoctorCity nVarchar(100),
 @DoctorState nChar(2),
 @DoctorZip	nVarchar(10)
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which inserts data into Doctors table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into Doctors
	(DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZip)
	Values
	(@DoctorFirstName, @DoctorLastName, @DoctorPhoneNumber, @DoctorAddress, @DoctorCity, @DoctorState, @DoctorZip)
    Set @DoctorID = @@IDENTITY;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsAppointments
(@AppointmentID int Output,
 @AppointmentDate date,
 @AppointmentTime time,
 @AppointmentPatientID int,
 @AppointmentDoctorID int,
 @AppointmentClinicID int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which inserts data into Appointments table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Insert Into Appointments
	(AppointmentDate, AppointmentTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID)
	Values
	(@AppointmentDate, @AppointmentTime, @AppointmentPatientID, @AppointmentDoctorID, @AppointmentClinicID)
	Set @AppointmentID = @@IDENTITY;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go
-- Updates --

Create Procedure pUpdClinics
(@ClinicID int,
 @ClinicName nVarchar(100),
 @ClinicPhoneNumber nVarchar(100),
 @ClinicAddress nVarchar(100),
 @ClinicCity nVarchar(100),
 @ClinicState	nChar(2),
 @ClinicZip nVarchar(10)
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which update data in Clinics table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Update Clinics
	 Set
	 ClinicName = @ClinicName, 
	 ClinicPhoneNumber = @ClinicPhoneNumber, 
	 ClinicAddress = @ClinicAddress, 
	 ClinicCity = @ClinicCity, 
	 ClinicState = @ClinicState, 
	 ClinicZip = @ClinicZip
	 Where ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdPatients
(@PatientID int, 
 @PatientFirstName nVarchar(100),
 @PatientLastName nVarchar(100),
 @PatientPhoneNumber nVarchar(100),
 @PatientAddress nVarchar(100),
 @PatientCity nVarchar(100),
 @PatientState nChar(2),
 @PatientZip nVarchar(10)
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which update data into Patients table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Update Patients
	 Set
	  PatientFirstName = @PatientFirstName, 
	  PatientLastName = @PatientLastName, 
	  PatientPhoneNumber = @PatientPhoneNumber, 
	  PatientAddress = @PatientAddress, 
	  PatientCity = @PatientCity, 
	  PatientState = @PatientState, 
	  PatientZip = @PatientZip
	  Where PatientID = @PatientID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go


Create Procedure pUpdDoctors
(@DoctorID int,
 @DoctorFirstName nVarchar(100),
 @DoctorLastName nVarchar(100),
 @DoctorPhoneNumber	nVarchar(100),
 @DoctorAddress	nVarchar(100),
 @DoctorCity nVarchar(100),
 @DoctorState nChar(2),
 @DoctorZip	nVarchar(10)
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which update data in Doctors table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Update Doctors
	 Set
	  DoctorFirstName = @DoctorFirstName,
	  DoctorLastName = @DoctorLastName,
	  DoctorPhoneNumber = @DoctorPhoneNumber, 
	  DoctorAddress = @DoctorAddress, 
	  DoctorCity = @DoctorCity, 
	  DoctorState = @DoctorState, 
	  DoctorZip = @DoctorZip
	  Where DoctorID = @DoctorID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdAppointments
(@AppointmentID int,
 @AppointmentDate date,
 @AppointmentTime Time,
 @AppointmentPatientID int,
 @AppointmentDoctorID int,
 @AppointmentClinicID int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which update data into Appointments table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Update Appointments
	 Set
	  AppointmentDate = @AppointmentDate,
	  AppointmentTime = @AppointmentTime,
	  AppointmentPatientID = @AppointmentPatientID, 
	  AppointmentDoctorID = @AppointmentDoctorID, 
	  AppointmentClinicID = @AppointmentClinicID
	  Where AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go
-- Deletes --

Create Procedure pDelClinics
(@ClinicID int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which delete data in Clinics table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete From Clinics
	 Where ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelPatients
(@PatientID int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which delete data into Patients table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete From Patients
	  Where PatientID = @PatientID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go


Create Procedure pDelDoctors
(@DoctorID int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which delete data in Doctors table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete From Doctors
	  Where DoctorID = @DoctorID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelAppointments
(@AppointmentID int
)
/* Author: <ByungSuJung>
** Desc: Create transaction stored procedure which delete data into Appointments table.
** Change Log: When,Who,What
** <2018-07-11>,<ByungSuJung>,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	Delete From Appointments
	  Where AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Print Error_Number()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

-- 5) Set the permissions ------------------------------------------------------

Begin
-- Clinics --
Deny Select, Insert, Update, Delete On Clinics To Public;
Grant Select On vClinics To Public;
Grant Exec On pInsClinics To Public;
Grant Exec On pUpdClinics To Public;
Grant Exec On pDelClinics To Public;
-- Patients -- 
Deny Select, Insert, Update, Delete On Patients To Public;
Grant Select On vPatients To Public;
Grant Exec On pInsPatients To Public;
Grant Exec On pUpdPatients To Public;
Grant Exec On pDelPatients To Public;
-- Doctors -- 
Deny Select, Insert, Update, Delete On Doctors To Public;
Grant Select On vDoctors To Public;
Grant Exec On pInsDoctors To Public;
Grant Exec On pUpdDoctors To Public;
Grant Exec On pDelDoctors To Public;
-- Appointments -- 
Deny Select, Insert, Update, Delete On Appointments To Public;
Grant Select On vAppointments To Public;
Grant Exec On pInsAppointments To Public;
Grant Exec On pUpdAppointments To Public;
Grant Exec On pDelAppointments To Public;

Grant Select On vClinicPatientDoctorAppointment To Public;

End

-- 6) Test the views and stored procedures -------------------------------------

Declare @Status int, @NewClinicID int, @NewPatientID int, @NewDoctorID int, @NewAppointmentID int;

------------------------Insert-----------------------------

Begin
-- Clinics --
 Exec @Status = pInsClinics
	  @ClinicID = @NewClinicID Output,
	  @ClinicName = 'ClinicA', 
	  @ClinicPhoneNumber = '206-999-9999', 
	  @ClinicAddress = '4225 9th Ave', 
	  @ClinicCity = 'Seattle', 
	  @ClinicState = 'WA', 
	  @ClinicZip = '98105'
 Select Case @Status
  When +1 Then 'Insert was successful'
  When -1 then 'Insert failed. Commom issues: Duplicate Data'
  End As [Status]

-- Patients --
 Exec @Status = pInsPatients
	  @PatientID = @NewPatientID Output,
	  @PatientFirstName = 'Jay', 
	  @PatientLastName = 'Jung', 
	  @PatientPhoneNumber = '206-888-8888', 
	  @PatientAddress = '4324 6th Ave', 
	  @PatientCity = 'Seattle', 
	  @PatientState = 'WA', 
	  @PatientZip = '98103'
 Select Case @Status
  When +1 Then 'Insert was successful'
  When -1 then 'Insert failed. Commom issues: Duplicate Data'
  End As [Status]

-- Doctors --
 Exec @Status = pInsDoctors
	  @DoctorID = @NewDoctorID Output,
	  @DoctorFirstName = 'Bob', 
	  @DoctorLastName = 'Smith', 
	  @DoctorPhoneNumber = '233-444-5555', 
	  @DoctorAddress = '3235 8th Ave', 
	  @DoctorCity = 'Seattle', 
	  @DoctorState = 'WA', 
	  @DoctorZip = '98101'
 Select Case @Status
  When +1 Then 'Insert was successful'
  When -1 then 'Insert failed. Commom issues: Duplicate Data'
  End As [Status]

-- Appointments --
 Exec @Status = pInsAppointments
	  @AppointmentID = @NewAppointmentID Output,
	  @AppointmentDate = '2018-08-11',
	  @AppointmentTime = '11:11',
	  @AppointmentPatientID = @NewPatientID, 
	  @AppointmentDoctorID = @NewDoctorID, 
	  @AppointmentClinicID = @NewClinicID
 Select Case @Status
  When +1 Then 'Insert was successful'
  When -1 then 'Insert failed. Commom issues: Duplicate Data'
  End As [Status]

End
Select * From vClinics
Select * From vPatients
Select * From vDoctors
Select * From vAppointments
Select * From vClinicPatientDoctorAppointment
  ----------------------- Update ----------------------

Begin
-- Clinics --
 Exec @Status = pUpdClinics
	  @ClinicID = @NewClinicID,
	  @ClinicName = 'ClinicB', 
	  @ClinicPhoneNumber = '226-999-9999', 
	  @ClinicAddress = '4444 9th Ave', 
	  @ClinicCity = 'Seattle', 
	  @ClinicState = 'WA', 
	  @ClinicZip = '98101'
 Select Case @Status
  When +1 Then 'Update was successful'
  When -1 then 'Update failed. Commom issues: Duplicate Data'
  End As [Status]

-- Patients --
 Exec @Status = pUpdPatients
	  @PatientID = @NewPatientID,
	  @PatientFirstName = 'Jayz', 
	  @PatientLastName = 'Jungz', 
	  @PatientPhoneNumber = '216-888-8888', 
	  @PatientAddress = '432444 6th Ave', 
	  @PatientCity = 'Seattle', 
	  @PatientState = 'WA', 
	  @PatientZip = '98100'
 Select Case @Status
  When +1 Then 'Update was successful'
  When -1 then 'Update failed. Commom issues: Duplicate Data'
  End As [Status]

-- Doctors --
 Exec @Status = pUpdDoctors
	  @DoctorID = @NewDoctorID,
	  @DoctorFirstName = 'zBob', 
	  @DoctorLastName = 'Smithz', 
	  @DoctorPhoneNumber = '231-444-5555', 
	  @DoctorAddress = '3235333 8th Ave', 
	  @DoctorCity = 'Seattle', 
	  @DoctorState = 'WA', 
	  @DoctorZip = '98101'
 Select Case @Status
  When +1 Then 'Update was successful'
  When -1 then 'Update failed. Commom issues: Duplicate Data'
  End As [Status]

-- Appointments --
 Exec @Status = pUpdAppointments
	  @AppointmentID = @NewAppointmentID,
	  @AppointmentDate = '2018-08-01', 
	  @AppointmentTime = '12:00',
	  @AppointmentPatientID = @NewPatientID,  
	  @AppointmentDoctorID = @NewDoctorID, 
	  @AppointmentClinicID = @NewClinicID
 Select Case @Status
  When +1 Then 'Update was successful'
  When -1 then 'Update failed. Commom issues: Duplicate Data'
  End As [Status]

End

Select * From vClinics
Select * From vPatients
Select * From vDoctors
Select * From vAppointments
Select * From vClinicPatientDoctorAppointment
------------------------- Delete --------------------------
 
 Begin

 -- Appointment --
 Exec @Status = pDelAppointments
	  @AppointmentID = @NewAppointmentID
 Select Case @Status
  When +1 Then 'Delete was successful'
  When -1 then 'Delete failed. Commom issues: Foreign Key Violation'
  End As [Status];

 -- Clinic --
 Exec @Status = pDelClinics
	  @ClinicID = @NewClinicID
 Select Case @Status
  When +1 Then 'Delete was successful'
  When -1 then 'Delete failed. Commom issues: Foreign Key Violation'
  End As [Status];

 -- Doctor --
 Exec @Status = pDelDoctors
	  @DoctorID = @NewDoctorID
 Select Case @Status
  When +1 Then 'Delete was successful'
  When -1 then 'Delete failed. Commom issues: Foreign Key Violation'
  End As [Status];
 -- Patient --
 Exec @Status = pDelPatients
	  @PatientID = @NewPatientID
 Select Case @Status
  When +1 Then 'Delete was successful'
  When -1 then 'Delete failed. Commom issues: Foreign Key Violation'
  End As [Status];

End

Select * From vClinics
Select * From vPatients
Select * From vDoctors
Select * From vAppointments
Select * From vClinicPatientDoctorAppointment