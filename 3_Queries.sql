USE EmergencyHealthcareDB;

-- 1. INNER JOIN
-- Display Emergency Requests with Patient and Hospital
SELECT
    er.Request_ID,
    p.Name AS Patient_Name,
    h.Hospital_Name,
    er.Emergency_Type,
    er.Priority_Level,
    er.Status
FROM Emergency_Request er
INNER JOIN Patient p
    ON er.Patient_ID = p.Patient_ID
INNER JOIN Hospital h
    ON er.Hospital_ID = h.Hospital_ID;

-- 2. LEFT JOIN
-- Display all Hospitals and their ICU Beds
SELECT
    h.Hospital_ID,
    h.Hospital_Name,
    i.Bed_ID,
    i.Bed_Number,
    i.Availability_Status
FROM Hospital h
LEFT JOIN ICU_Bed i
    ON h.Hospital_ID = i.Hospital_ID;

-- 3. SELF JOIN
-- Find patients having the same Blood Group
SELECT
    p1.Name AS Patient_1,
    p2.Name AS Patient_2,
    p1.Blood_Group
FROM Patient p1
INNER JOIN Patient p2
    ON p1.Blood_Group = p2.Blood_Group
    AND p1.Patient_ID < p2.Patient_ID
LIMIT 20;

-- 4. MULTI-TABLE JOIN
-- Display Emergency Request, Patient, Ambulance and Dispatch
SELECT
    er.Request_ID,
    p.Name AS Patient_Name,
    er.Priority_Level,
    a.Vehicle_Number,
    d.Dispatch_Time,
    d.Arrival_Time,
    d.Status AS Dispatch_Status
FROM Emergency_Request er
INNER JOIN Patient p
    ON er.Patient_ID = p.Patient_ID
INNER JOIN Dispatch d
    ON er.Request_ID = d.Request_ID
INNER JOIN Ambulance a
    ON d.Ambulance_ID = a.Ambulance_ID;

-- 5. AGGREGATE FUNCTION + GROUP BY
-- Count emergency requests handled by each hospital
SELECT
    h.Hospital_ID,
    h.Hospital_Name,
    COUNT(er.Request_ID) AS Total_Requests
FROM Hospital h
INNER JOIN Emergency_Request er
    ON h.Hospital_ID = er.Hospital_ID
GROUP BY
    h.Hospital_ID,
    h.Hospital_Name;

-- 6. GROUP BY + COUNT
-- Count emergency requests according to priority level
SELECT
    Priority_Level,
    COUNT(*) AS Total_Requests
FROM Emergency_Request
GROUP BY Priority_Level;

-- 7. GROUP BY + AVG
-- Average available blood units for each blood group
SELECT
    Blood_Group,
    AVG(Units_Available) AS Average_Units
FROM Blood_Bank
GROUP BY Blood_Group;

-- 8. GROUP BY + SUM
-- Total blood units available at each hospital
SELECT
    h.Hospital_ID,
    h.Hospital_Name,
    SUM(b.Units_Available) AS Total_Blood_Units
FROM Hospital h
INNER JOIN Blood_Bank b
    ON h.Hospital_ID = b.Hospital_ID
GROUP BY
    h.Hospital_ID,
    h.Hospital_Name;

-- 9. GROUP BY + HAVING
-- Hospitals having more than 10 emergency requests
SELECT
    h.Hospital_ID,
    h.Hospital_Name,
    COUNT(er.Request_ID) AS Total_Requests
FROM Hospital h
INNER JOIN Emergency_Request er
    ON h.Hospital_ID = er.Hospital_ID
GROUP BY
    h.Hospital_ID,
    h.Hospital_Name
HAVING COUNT(er.Request_ID) > 10;

-- 10. SUBQUERY
-- Find patients who have Critical emergency requests
SELECT
    Patient_ID,
    Name,
    Blood_Group
FROM Patient
WHERE Patient_ID IN (
    SELECT Patient_ID
    FROM Emergency_Request
    WHERE Priority_Level = 'Critical'
);

-- 11. SUBQUERY + AVG
-- Find hospitals having more emergency requests than the average number of requests per hospital
SELECT
    h.Hospital_ID,
    h.Hospital_Name,
    COUNT(er.Request_ID) AS Total_Requests
FROM Hospital h
INNER JOIN Emergency_Request er
    ON h.Hospital_ID = er.Hospital_ID
GROUP BY
    h.Hospital_ID,
    h.Hospital_Name
HAVING COUNT(er.Request_ID) > (
    SELECT AVG(Request_Count)
    FROM (
        SELECT COUNT(*) AS Request_Count
        FROM Emergency_Request
        GROUP BY Hospital_ID
    ) AS Hospital_Request_Counts
);

-- 12. CORRELATED SUBQUERY
-- Find patients whose age is greater than the average age of patients with the same blood group
SELECT
    p.Patient_ID,
    p.Name,
    p.Age,
    p.Blood_Group
FROM Patient p
WHERE p.Age > (
    SELECT AVG(p2.Age)
    FROM Patient p2
    WHERE p2.Blood_Group = p.Blood_Group
);