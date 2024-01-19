-- * set RecordType fields.
WITH a AS (SELECT Code, RType FROM db2.SCPropUse)
UPDATE Spec_RUBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a)
 THEN (SELECT RType FROM a 
   WHERE Code IS PropUse)
ELSE RecordType
END;

--deletetoEnd;

