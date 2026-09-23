USE EmergencyHealthcareDB;

-- INDEXING + EXPLAIN

-- QUERY 1: Emergency Requests by Hospital and Priority

-- BEFORE INDEX
EXPLAIN
SELECT
    er.Request_ID,
    er.Priority_Level,
    er.Request_Time,
    h.Hospital_Name
FROM Emergency_Request er
INNER JOIN Hospital h
    ON er.Hospital_ID = h.Hospital_ID
WHERE er.Hospital_ID = 5
  AND er.Priority_Level = 'Critical'
ORDER BY er.Request_Time DESC;

-- CREATE COMPOSITE INDEX
CREATE INDEX idx_request_hospital_priority_time
ON Emergency_Request (Hospital_ID, Priority_Level, Request_Time);

-- AFTER INDEX
EXPLAIN
SELECT
    er.Request_ID,
    er.Priority_Level,
    er.Request_Time,
    h.Hospital_Name
FROM Emergency_Request er
INNER JOIN Hospital h
    ON er.Hospital_ID = h.Hospital_ID
WHERE er.Hospital_ID = 5
  AND er.Priority_Level = 'Critical'
ORDER BY er.Request_Time DESC;

-- QUERY 2: Ambulance Dispatch Search

-- BEFORE INDEX
EXPLAIN
SELECT
    a.Ambulance_ID,
    a.Vehicle_Number,
    a.Status,
    d.Dispatch_Time
FROM Ambulance a
INNER JOIN Dispatch d
    ON a.Ambulance_ID = d.Ambulance_ID
WHERE a.Status = 'On Duty'
ORDER BY d.Dispatch_Time DESC;

-- CREATE INDEXES
CREATE INDEX idx_ambulance_status
ON Ambulance (Status);

CREATE INDEX idx_dispatch_ambulance_time
ON Dispatch (Ambulance_ID, Dispatch_Time);

-- AFTER INDEX
EXPLAIN
SELECT
    a.Ambulance_ID,
    a.Vehicle_Number,
    a.Status,
    d.Dispatch_Time
FROM Ambulance a
INNER JOIN Dispatch d
    ON a.Ambulance_ID = d.Ambulance_ID
WHERE a.Status = 'On Duty'
ORDER BY d.Dispatch_Time DESC;

-- VERIFY INDEXES
SHOW INDEX FROM Emergency_Request;
SHOW INDEX FROM Ambulance;
SHOW INDEX FROM Dispatch;