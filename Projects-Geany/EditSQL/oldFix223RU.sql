--Fix223RU.sql - Fix RU parcels in territory 223.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * .   wmk.   (automated) udpate FixFromSC (Terr124 template).
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
--	9/23/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 5/9/21.	wmk.	original code (compatible with make).
-- * 6/12/21.	wmk.	(automated) ($)folderbase support.
-- * 9/23/21.	wmk.	revert $ to % in strings.
-- *
-- * Notes. whatever relevant for this RU download..
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * DelStrays - Delete stray records from RU download.
-- * FixWhatever - Fix whatever for territory 223.
-- *;

-- ** AttachDBs **********
-- *	5/9/21.	wmk.
-- *---------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *		SitusDups - table of ambiguous situs addresses with account #s
-- *		SitusConv - situs conversion table unitaddress <-> scpa situs
-- *		AddrXcpt - address exceptions
-- *	Terr223_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr223_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 223
-- *	Terr223_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr223_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr223_RUPoly)
-- *
-- * Exit DB and table results.
-- *
-- * Notes.
-- *;

-- * junk as main;
.open '$pathbase/DB-Dev/junk.db'

ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
 AS db2;
--SELECT tbl_name FROM db2.sqlite_master 
-- WHERE type is "table";
--pragma db2.table_info(Terr86777);
 
ATTACH '$pathbase'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AddrXcpt); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terr223/Terr223_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr223_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr223/Terr223_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr223_RUBridge);

-- ** END AttachDBs **********;

-- ** DelStrays **********
-- *	5/9/21.	wmk.
-- *--------------------------
-- *
-- * DelStrays - Delete stray records from RU download.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes.
-- *;

-- * DBs attached above;

-- * eliminate BAINE RD, MEYERS RD, PALM DR,
-- *  FIRST DIRT RD, 1ST DIRT RD, ELLIOTT ST
DELETE FROM Terr223_RUBridge 
WHERE  UNITADDRESS LIKE "%Baine%" 
  OR UNITADDRESS LIKE "%Meyers%"
  OR UNITADDRESS LIKE "%Palm Dr%"
  OR UNITADDRESS LIKE "%FIRST DIRT%"
  OR UNITADDRESS LIKE "%1ST DIRT%"
  OR UNITADDRESS LIKE "%ELLIOTT%";

-- * eliminate KENNEDY DR >= 3313
DELETE FROM Terr223_RUBridge
WHERE CAST(SUBSTR(UNITADDRESS,1,4) AS INT) >= 3313
 AND UNITADDRESS LIKE "%KENNEDY RD%";

UPDATE Terr223_RUBridge
set DelPending = 
CASE
WHEN INSTR(UNITADDRESS, " ") = 4
 AND (SUBSTR(UNITADDRESS,3,1) IS "1"
	OR SUBSTR(UNITADDRESS,3,1) IS  "3"
	OR SUBSTR(UNITADDRESS,3,1) IS  "5"
	OR SUBSTR(UNITADDRESS,3,1) IS  "7"
	OR SUBSTR(UNITADDRESS,3,1) IS  "9")
   THEN ""
WHEN INSTR(UNITADDRESS, " ") = 5
   THEN 1
WHEN INSTR(UNITADDRESS, " ") = 4 
 AND CAST(SUBSTR(UNITADDRESS,1,3) AS INT) >= 980
   THEN 1
ELSE DelPending
END
WHERE UNITADDRESS LIKE "%JACKSON%"
;

DELETE FROM Terr223_RUBridge
WHERE DelPending IS 1;

-- ** END DelStrays **********;

-- ** FixWhatever **********
-- *	5/9/21.	wmk.
-- *--------------------------
-- *
-- * FixWhatever - Fix whatever for territory 223.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr223_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr223_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr223_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr223_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr223_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Whatever
-- *;

-- * DBs attached above;

-- * remove 'N ' prefix Jackson, Havana Rd;
UPDATE Terr223_RUBridge
SET UnitAddress = 
CASE 
WHEN substr(trim(SUBSTR(UnitAddress,INSTR(UnitAddress,' '))),1,2) IS 'N ' 
 THEN SUBSTR(UnitAddress,1,6) || TRIM(SUBSTR(UnitAddress,9))
ELSE UnitAddress
END
WHERE UnitAddress LIKE "%Havana%" 
   OR UnitAddress LIKE "%Jackson%";

-- * add "N" suffix to Havana, Jackson records;
UPDATE Terr223_RUBridge
SET UnitAddress = 
CASE 
WHEN SUBSTR(UnitAddress,LENGTH(UnitAddress)-1,2) IS NOT " N" 
 THEN TRIM(UnitAddress) || " N"
ELSE UnitAddress
END
WHERE UnitAddress LIKE "%Havana%" 
   OR UnitAddress LIKE "%Jackson%";

-- * fix 506B   Havana Rd to 506... B;
UPDATE Terr223_RUBridge
SET Unit = "B",
 UnitAddress = SUBSTR(UnitAddress,1,3)
 || ' ' || SUBSTR(UnitAddress,5)
WHERE UnitAddress LIKE "506B  HAVANA%";

 
-- ** END FixWhatever **********;


--begin SPLIT
--begin FixFromSC
-- ** FixFromSC **********
-- *	5/9/21.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 223.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr223_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr223_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 223
-- *	Terr223_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr223_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr223_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr223_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr223_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Fix records not fixed above.
-- *;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr223_SCBridge)
UPDATE Terr223_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT Acct FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE OwningParcel
END,
SitusAddress = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT Situs FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE SitusAddress
END,
Phone2 =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT Hstead FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE Phone2
END,
PropUse = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE PropUse
END,
DoNotCall = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT DNC FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE DoNotCall
END,
RSO = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT SCSO FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE RSO
END,
"Foreign" =
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT FL FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE "Foreign"
END,
RecordType = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT RecType FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE RecordType
END
WHERE OwningParcel is "-"; 

-- ** END FixFromSC **********;
--/**/

.quit

-- **************************************************


.quit
-- ** END FiX223RU **********;

-- * fix 506B   Havana Rd to 506... B;
UPDATE Terr223_RUBridge
SET Unit = "B",
 UnitAddress = SUBSTR(UnitAddress,1,3)
 || SUBSTR(UnitAddress,5)
WHERE UnitAddress LIKE "506B   HAVANA%";

-- *** below code messes all records up...;
-- * fix any address where unit conjoined with number;
WITH a AS (SELECT OWningParcel AS Acct, 
 SUBSTR(UnitAddress,INSTR(UnitAddress,' ')-1,1)
 AS LastDigit FROM Terr223_RUBridge
where INSTR('0123456789',LastDigit) = 0)
UPDATE Terr223_RUBridge 
SET UnitAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')-2)
  || ' ' || SUBSTR(UnitAddress,INSTR(UnitAddress,' '))
ELSE UnitAddress
END,
 Unit =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN (SELECT LastDigit FROM a
  WHERE Acct IS OwningParcel)
ELSE Unit
END
WHERE  INSTR('0123456789',SUBSTR(UnitAddress,INSTR(UnitAddress,' ')-1,1) )
  <> 0
;

-- ** subquery **********
-- *	5/9/21.	wmk.
-- *--------------------------
-- *
-- * subquery_name - simple description.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes.
-- *;

-- ** END query **********;

.quit
-- ** END Fi223xRU **********;

--* END NEWEST

-- * fix 3-digit Jackson Rd addresses;
WITH a as (select "account #" AS aCCT,
"SITUS ADDRESS (PROPERTY ADDRESS)" as Situs,
SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",1,3) 
 || " " || SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",
 5,35) AS MatchAddr
FROM NVENALL 
WHERE SItus like "%JACKSON RD%")
UPDATE Terr222_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN TRIM(UPPER(UNITADDRESS)) 
 IN (SELECT MatchAddr FROM a)
THEN (SELECT Acct FROM a 
 WHERE MatchAddr IS TRIM(UPPER(UNITADDRESS))
)
ELSE OWNINGPARCEL
END 
WHERE OWNINGPARCEL IS "-";

-- * then fix 4-digit addresses on Jackson Rd;
WITH a as (select "account #" AS aCCT,
CASE 
when SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",5,1)
 is "N"
THEN  SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",1,4) 
 || " "
 || SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",6,35)
ELSE "" 
END AS MatchAddr
FROM NVENALL 
WHERE MatchAddr LIKE "%JACKSON RD%")
UPDATE Terr222_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN TRIM(UPPER(UNITADDRESS)) 
 IN (SELECT MatchAddr FROM a)
THEN (SELECT Acct FROM a 
 WHERE MatchAddr IS TRIM(UPPER(UNITADDRESS))
)
ELSE OWNINGPARCEL
END 
WHERE OWNINGPARCEL IS "-";

-- * fix 3-digit Havana Rd addresses;
WITH a as (select "account #" AS aCCT,
"SITUS ADDRESS (PROPERTY ADDRESS)" as Situs,
case
WHEN SUBSTR("situs address (PROPERTY ADDRESS)",4,1) 
is "N"
 THEN  
SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",1,3) 
 || "   " || trim(SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",
 5,31))
 ELSE "" 
 END AS MatchAddr
FROM NVENALL 
WHERE SItus like "%HAVANA RD%"
ORDER BY MatchAddr)
UPDATE Terr222_RUBridge
SET OWNINGPARCEL = 
CASE
WHEN TRIM(UPPER(UNITADDRESS)) 
 IN (SELECT MatchAddr FROM a)
THEN (SELECT Acct FROM a 
 WHERE MatchAddr IS TRIM(UPPER(UNITADDRESS))
)
ELSE OWNINGPARCEL
END 
WHERE OWNINGPARCEL IS "-";

-- * Fix 1st Dirt Rd RU records;
-- * in the SC data this is FIRST DIRT RD;
WITH a AS (SELECT "account #" as Acct,
 SUBSTR("SITUS ADDRESS (PROPERTY ADDRESS)",1,3) AS HouseNum
 FROM NVENALL 
 WHERE "SITUS ADDRESS (PROPERTY ADDRESS)"
 LIKE "%FIRST DIRT")
UPDATE Terr222_RUBridge
SET OWNINGPARCEL = 
CASE 
WHEN SUBSTR(UNITADDRESS,1,3) IN (SELECT HouseNum from a) 
 THEN (SELECT Acct from a
  WHERE HouseNum is SUBSTR(UNITADDRESS,1,3)
 )
ELSE OWNINGPARCEL
END
WHERE OWNINGPARCEL IS "-" 
 AND UNITADDRESS LIKE "%1ST DIRT%";

-- * now look up exceptions.
WITH a AS (SELECT PropID, UnitAddress AS StreetAddr,
 RecordType as RecType FROM AddrXcpt 
WHERE CONGTERR IS "222" )
SELECT * FROM TERR222_rubridge
WHERE uNITaDDRESS IN (SELECT Unitaddress from a);
update Terr222_RUBridge 
SET OwningParcel =
CASE 
WHEN UnitAddress IN (SELECT StreetAddr from a)
 THEN (SELECT PropID FROM a
  WHERE StreetAddr IS UnitAddress
 )
ELSE OwningParcel 
END,
 SitusAddress =
 CASE 
WHEN UnitAddress IN 
 THEN (SELECT Situs FROM a
  WHERE StreetAddr IS UnitAddress
 )
ELSE SitusAddress
END, 
 RecordType =
CASE 
WHEN UnitAddress IN 
 THEN (SELECT RecType FROM a
  WHERE StreetAddr IS UnitAddress
 )
ELSE RecordType
END
WHERE OwningParcel IS "-";

-- * now set missing fields in records using SC data and property IDs.
WITH a AS (SELECT OwningParel AS Acct, SitusAddress AS Situs,
 Phone2 AS Hstead, DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
 PropUse AS UseType, RecordType AS RecType
 FROM Terr222_SCBridge)
UPDATE Terr222_RUBridge
SET SitusAddress = 
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
  THEN (SELECT Situs FROM a 
   WHERE Acct IS OwningParcel
  )
ELSE SitusAddress
END,
 Phone2 = 
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
  THEN (SELECT HStead FROM a 
   WHERE Acct IS OwningParcel
  )
ELSE Phone2
END,
 DoNotCall = 
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
  THEN (SELECT DNC FROM a 
   WHERE Acct IS OwningParcel
  )
ELSE DoNotCall
END,
 RSO =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
  THEN (SELECT SCSO FROM a 
   WHERE Acct IS OwningParcel
  )
ELSE RSO
END,
 "Foreign" = 
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
  THEN (SELECT FL FROM a 
   WHERE Acct IS OwningParcel
  )
ELSE "Foreign"
END,
 PropUse = 
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
  THEN (SELECT UseType FROM a 
   WHERE Acct IS OwningParcel
  )
ELSE PropUse
END,
 RecordType =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
  THEN (SELECT RecType FROM a 
   WHERE Acct IS OwningParcel
  )
ELSE RecordType
END
WHERE PropUse ISNULL OR LENGTH(PropUse) = 0;

-- * set missing situs address and propuse from nvenAll both tables.
WITH a AS (SELECT "ACCOUNT #" AS Acct, 
 "situs address (property address)" AS Situs,
 "property use code" AS UseType
 FROM Terr86777 
 WHERE Acct
  IN (SELECT OwningParcel FROM Terr222_SCBridge))
UPDATE Terr222_SCBridge
SET SitusAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
 THEN (SELECT Situs FROM a
  WHERE Acct IS OwningParcel
 )
ELSE SitusAddress
END, 
 PropUse =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
 THEN (SELECT UseType FROM a
  WHERE Acct IS OwningParcel
 )
ELSE PropUse
END 
WHERE PropUse ISNULL OR LENGTH(PropertyUse) = 0; 

WITH a AS (SELECT "ACCOUNT #" AS Acct, 
 "situs address (property address)" AS Situs,
 "property use code" AS UseType
 FROM Terr86777 
 WHERE Acct IN (SELECT OwningParcel FROM Terr222_RUBridge)
UPDATE Terr222_RUBridge
SET SitusAddress =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
 THEN (SELECT Situs FROM a
  WHERE Acct IS OwningParcel
 )
ELSE SitusAddress
END, 
 PropUse =
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a) 
 THEN (SELECT UseType FROM a
  WHERE Acct IS OwningParcel
 )
ELSE PropUse
END 
WHERE PropUse ISNULL OR LENGTH(PropUse) = 0; 
