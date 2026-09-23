USE EmergencyHealthcareDB;

-- 1. EMERGENCY REQUEST VIEW
-- Patient, Hospital and Emergency Request Details
CREATE OR REPLACE VIEW Emergency_Request_View AS
SELECT
    er.Request_ID,
    p.Patient_ID,
    p.Name AS Patient_Name,
    p.Blood_Group,
    h.Hospital_ID,
    h.Hospital_Name,
    h.Location,
    er.Emergency_Type,
    er.Priority_Level,
    er.Request_Time,
    er.Status
FROM Emergency_Request er
INNER JOIN Patient p
    ON er.Patient_ID = p.Patient_ID
INNER JOIN Hospital h
    ON er.Hospital_ID = h.Hospital_ID;

-- Check View 1
SELECT * FROM Emergency_Request_View;

-- 2. AMBULANCE DISPATCH VIEW
-- Ambulance, Driver, Hospital and Dispatch Details
CREATE OR REPLACE VIEW Ambulance_Dispatch_View AS
SELECT
    d.Dispatch_ID,
    er.Request_ID,
    p.Name AS Patient_Name,
    a.Ambulance_ID,
    a.Vehicle_Number,
    dr.Name AS Driver_Name,
    h.Hospital_Name,
    d.Dispatch_Time,
    d.Arrival_Time,
    d.Status AS Dispatch_Status
FROM Dispatch d
INNER JOIN Emergency_Request er
    ON d.Request_ID = er.Request_ID
INNER JOIN Patient p
    ON er.Patient_ID = p.Patient_ID
INNER JOIN Ambulance a
    ON d.Ambulance_ID = a.Ambulance_ID
INNER JOIN Driver dr
    ON a.Ambulance_ID = dr.Ambulance_ID
INNER JOIN Hospital h
    ON a.Hospital_ID = h.Hospital_ID;

-- Check View 2
SELECT * FROM Ambulance_Dispatch_View;

-- CHECK ALL VIEWS
SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';