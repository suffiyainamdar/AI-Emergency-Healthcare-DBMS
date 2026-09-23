USE EmergencyHealthcareDB;

-- Procedure setup + creation
DROP PROCEDURE IF EXISTS GetRequestsByPriority;

DELIMITER //

CREATE PROCEDURE GetRequestsByPriority(
    IN p_priority VARCHAR(10)
)
BEGIN
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
        ON er.Hospital_ID = h.Hospital_ID
    WHERE er.Priority_Level = p_priority;
END //

DELIMITER ;

CALL GetRequestsByPriority('Critical');

-- Create the trigger
DROP TRIGGER IF EXISTS trg_dispatch_ambulance_status;

DELIMITER //

CREATE TRIGGER trg_dispatch_ambulance_status
AFTER INSERT ON Dispatch
FOR EACH ROW
BEGIN
    IF NEW.Status IN ('Dispatched', 'On Duty', 'En Route') THEN
        UPDATE Ambulance
        SET Status = 'On Duty'
        WHERE Ambulance_ID = NEW.Ambulance_ID;
    END IF;
END //

DELIMITER ;

SHOW PROCEDURE STATUS
WHERE Db = 'EmergencyHealthcareDB';

SHOW TRIGGERS
FROM EmergencyHealthcareDB;