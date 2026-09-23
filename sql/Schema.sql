-- TAE 2
-- Project: AI-Powered Emergency Healthcare Connector & Smart Ambulance Dispatch Management Database
-- Schema Creation
DROP DATABASE IF EXISTS EmergencyHealthcareDB;
CREATE DATABASE EmergencyHealthcareDB;
USE EmergencyHealthcareDB;

-- 1. PATIENT
CREATE TABLE Patient (
    Patient_ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Age INT CHECK (Age > 0),
    Gender CHAR(1),
    Blood_Group VARCHAR(3),
    Contact_No VARCHAR(15) UNIQUE,
    Address VARCHAR(100)
);

-- 2. HOSPITAL
CREATE TABLE Hospital (
    Hospital_ID INT PRIMARY KEY,
    Hospital_Name VARCHAR(60) NOT NULL,
    Location VARCHAR(50),
    Contact_No VARCHAR(15),
    Emergency_Contact VARCHAR(15)
);

-- 3. DOCTOR
CREATE TABLE Doctor (
    Doctor_ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Specialization VARCHAR(50),
    Contact_No VARCHAR(15) UNIQUE,
    Hospital_ID INT NOT NULL,

    FOREIGN KEY (Hospital_ID)
        REFERENCES Hospital(Hospital_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 4. AMBULANCE
CREATE TABLE Ambulance (
    Ambulance_ID INT PRIMARY KEY,
    Vehicle_Number VARCHAR(20) UNIQUE,
    Status VARCHAR(20)
        CHECK (Status IN ('Available', 'On Duty', 'Maintenance')),
    Hospital_ID INT NOT NULL,

    FOREIGN KEY (Hospital_ID)
        REFERENCES Hospital(Hospital_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 5. DRIVER
CREATE TABLE Driver (
    Driver_ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Contact_No VARCHAR(15) UNIQUE,
    License_Number VARCHAR(20) UNIQUE,
    Ambulance_ID INT NOT NULL,

    FOREIGN KEY (Ambulance_ID)
        REFERENCES Ambulance(Ambulance_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 6. EMERGENCY REQUEST
CREATE TABLE Emergency_Request (
    Request_ID INT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Hospital_ID INT NOT NULL,
    Emergency_Type VARCHAR(50),
    Priority_Level VARCHAR(10)
        CHECK (Priority_Level IN ('Critical', 'High', 'Medium', 'Low')),
    Request_Time DATETIME,
    Status VARCHAR(20),

    FOREIGN KEY (Patient_ID)
        REFERENCES Patient(Patient_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Hospital_ID)
        REFERENCES Hospital(Hospital_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 7. DISPATCH
CREATE TABLE Dispatch (
    Dispatch_ID INT PRIMARY KEY,
    Request_ID INT NOT NULL,
    Ambulance_ID INT NOT NULL,
    Dispatch_Time DATETIME,
    Arrival_Time DATETIME,
    Status VARCHAR(20),

    FOREIGN KEY (Request_ID)
        REFERENCES Emergency_Request(Request_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (Ambulance_ID)
        REFERENCES Ambulance(Ambulance_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 8. ICU BED
CREATE TABLE ICU_Bed (
    Bed_ID INT PRIMARY KEY,
    Hospital_ID INT NOT NULL,
    Bed_Number VARCHAR(10),
    Availability_Status VARCHAR(15)
        CHECK (Availability_Status IN ('Available', 'Occupied', 'Reserved')),

    FOREIGN KEY (Hospital_ID)
        REFERENCES Hospital(Hospital_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 9. BLOOD BANK
CREATE TABLE Blood_Bank (
    Blood_Bank_ID INT PRIMARY KEY,
    Hospital_ID INT NOT NULL,
    Blood_Group VARCHAR(3),
    Units_Available INT
        CHECK (Units_Available >= 0),

    FOREIGN KEY (Hospital_ID)
        REFERENCES Hospital(Hospital_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 10. PHARMACY
CREATE TABLE Pharmacy (
    Pharmacy_ID INT PRIMARY KEY,
    Hospital_ID INT NOT NULL,
    Pharmacy_Name VARCHAR(50) NOT NULL,
    Contact_No VARCHAR(15),
    Medicine_Availability VARCHAR(20),

    FOREIGN KEY (Hospital_ID)
        REFERENCES Hospital(Hospital_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 11. EMERGENCY CONTACT
CREATE TABLE Emergency_Contact (
    Contact_ID INT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Relationship VARCHAR(30),
    Contact_No VARCHAR(15),

    FOREIGN KEY (Patient_ID)
        REFERENCES Patient(Patient_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- CHECK ALL TABLES
SHOW TABLES;