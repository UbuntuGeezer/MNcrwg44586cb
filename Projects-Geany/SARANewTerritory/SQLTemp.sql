-- SQLTemp.sql - SCTidyTerr -Tidy up _SCBridge records in
--  new SCPA territory db.
.cd '/home/vncwmk3/Territories'
.cd './RawData/SCPA/SCPA-Downloads'
.shell touch SQLTrace.txt
.trace 'SQLTrace.txt'
.cd './Terr983'
.open Terr983_SC.db 
-- * SetSitusPropUse - Set Situs and PropUse fields in Terr983_SCBridge.;
ATTACH '/home/vncwmk3/Territories'
||		'/DB-Dev/VeniceNTerritory.db' 
AS db2;
WITH a AS (SELECT "ACCOUNT #", 
		"SITUS ADDRESS (PROPERTY ADDRESS)", "PROPERTY USE CODE"
	FROM NVENALL)
UPDATE Terr983_SCBridge
SET SitusAddress = 
    (SELECT "SITUS ADDRESS (PROPERTY ADDRESS)"
    FROM a 
    WHERE "ACCOUNT #" IS OwningParcel),
 PropUse = 
    (SELECT "PROPERTY USE CODE"
    FROM a 
    WHERE "ACCOUNT #" IS OwningParcel)
WHERE OwningParcel IN 
 (SELECT "ACCOUNT #" FROM a)
 AND (PropUse ISNULL OR PropUse IS "");
-- * SetDoNotCalls - Set DoNotCall, RSO and Foreign fields in Bridge.
ATTACH '/home/vncwmk3/Territories'
 ||		'/DB-Dev/TerrIDData.db'
 AS db4;
WITH a AS (SELECT * FROM db4.DoNotCalls
  WHERE TerrID IS 983)
UPDATE Terr983_SCBridge
SET DoNotCall =
	CASE 
	WHEN OwningParcel
	 IN (SELECT PropID FROM a)
   AND Unit IN (SELECT Unit FROM a 
       WHERE PropID IS OwningParcel)
	THEN 1
	ELSE ""
	END,
RSO =
	CASE 
	WHEN OwningParcel
	 IN (SELECT PropID FROM a)
   AND Unit IN (SELECT Unit FROM a 
       WHERE PropID IS OwningParcel)
	THEN 
	  (SELECT RSO FROM a 
		WHERE PROPID IS OwningParcel)
	ELSE RSO
	END,
"Foreign" = 
	CASE 
	WHEN OwningParcel
	 IN (SELECT PropID FROM a)
   AND Unit IN (SELECT Unit FROM a 
       WHERE PropID IS OwningParcel)
	THEN 
	  (SELECT "FOREIGN" FROM a 
		WHERE PROPID IS OwningParcel)
	ELSE "Foreign"
	END
 ;
-- * SetRecordTypes - Set DoNotCallReccordType fields in Bridge.;
WITH a AS (SELECT Code, RType FROM db2.SCPropUse)
UPDATE Terr983_SCBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a
   WHERE Code IS PropUse)
ELSE RecordType
END;
WITH a AS (SELECT "Account #" AS Acct,
 "Homestead Exemption" AS QHomestead
 FROM NVenAll
 WHERE Acct IN (SELECT OWNINGPARCEL
  FROM Terr983_SCBridge))
UPDATE Terr983_SCBridge 
SET Phone2 = 
CASE
WHEN (SELECT QHomestead FROM a 
   WHERE Acct IS OWNINGPARCEL) IS "YES"
   THEN "*"
WHEN (SELECT QHomestead FROM a 
   WHERE Acct IS OWNINGPARCEL) IS "NO"
   THEN ""
ELSE Phone2
END;
.quit
