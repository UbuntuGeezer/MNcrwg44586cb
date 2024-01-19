-- *procbodyhere;
-- * SCTidyTerr -Tidy up _SCBridge records in new SCPA territory db.
-- * 6/28/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777.
-- * 6/28/22.	wmk.	*procbody support.
-- * Legacy mods.
-- * 11/11/20.	wmk.	original code.
-- * 9/23/21.	wmk.	modify RecordType code to use SCPropUse table from
-- *			 Terr86777.db.
-- *;
.cd '$pathbase'
.cd './RawData/SCPA/SCPA-Downloads'
.shell touch SQLTrace.txt
.trace 'SQLTrace.txt'
.cd './Terr$TID'
.open $DB_NAME 
-- * SetSitusPropUse - Set Situs and PropUse fields in $TBL_NAME1.;
ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
AS db2;
-- * set Situs and Property Use;
WITH a AS (SELECT "ACCOUNT #", 
		"SITUS ADDRESS (PROPERTY ADDRESS)", "PROPERTY USE CODE"
	FROM Terr86777)
UPDATE $TBL_NAME1
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
-- * SetDoNotCalls - Set DoNotCall, RSO and Foreign fields in Bridge;
ATTACH '$pathbase'
 ||		'/DB-Dev/TerrIDData.db'
 AS db4;
WITH a AS (SELECT * FROM db4.DoNotCalls
  WHERE TerrID IS "$TID")
UPDATE $TBL_NAME1
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
UPDATE $TBL_NAME1
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a
   WHERE Code IS PropUse)
ELSE RecordType
END;
-- * change Phone2 field to homestead * where matched;
WITH a AS (SELECT "Account #" AS Acct,
 "Homestead Exemption" AS QHomestead
 FROM Terr86777
 WHERE Acct IN (SELECT OWNINGPARCEL
  FROM $TBL_NAME1))
UPDATE $TBL_NAME1 
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
-- *endprocbody;
