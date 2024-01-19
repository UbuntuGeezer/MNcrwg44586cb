WITH a AS (SELECT CONGTERRID FROM Spec_RUBridge
 WHERE CONGTERRID Is "279")
INSERT INTO TerrList 
(TerrID, COUNTS)
 SELECT "279",COUNT() CONGTERRID from a;


INSERT INTO TerrList
SELECT DISTINCT congterrid , 0
FROM Spec_RUBridge;

UPDATE TerrList
SET Counts =
case 
WHEN TerrID IS NOT ""
 THEN (SELECT COUNT() congterrid FROM Spec_RUBridge
  where congterrid is TerrID)
else Counts
END
where Counts = 0;

UPDATE TerrList
SET Counts =
case 
WHEN TerrID IS NOT ""
 THEN (SELECT COUNT() congterrid FROM Spec_RUBridge
  where congterrid is TerrID)
else Counts
END;


update Spec_RUBridge 
 set congterrid = "279"
WHERE UNITADDRESS LIKE "744%" 
 or unitaddress like "748%"
 or unitaddress like "750%"
 or unitaddress like "764%"
 or unitaddress like "760%";

update Spec_RUBridge 
 set congterrid = "280"
WHERE UNITADDRESS LIKE "740%" 
 or unitaddress like "742%"
 or unitaddress like "746%"
 or unitaddress like "752%"
 or unitaddress like "754%";

update Spec_RUBridge 
 set congterrid = "281"
WHERE UNITADDRESS LIKE "756%" 
 or unitaddress like "758%"
 or unitaddress like "762%"
 or unitaddress like "766%";

