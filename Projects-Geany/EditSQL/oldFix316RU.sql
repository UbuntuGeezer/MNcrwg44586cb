--Fix316RU.sql - Fix RU parcels in territory 316.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 7/9/22.   wmk.   (automated) udpate FixFromSC (Terr124 template).
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
-- * 1/13/22.	wmk.	(automated) ($)string repairs.
-- *  6/12/21.	wmk.	(automated) ($)folderbase support.
--	5/8/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 5/8/21.	wmk.	original code (compatible with make).
-- *
-- * Notes. whatever relevant for this RU download..
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * FixPinewood - Fix Pinewood records.
-- * Fix1505Colonia - Fix 1505 Colonia Ln.
-- * FixFromSC - Fix RU records from SC records for territory 316.
-- *;

-- ** AttachDBs **********
-- *	5/8/21.	wmk.
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
-- *	Terr316_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr316_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 316
-- *	Terr316_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr316_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr316_RUPoly)
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
 ||		'/RawData/SCPA/SCPA-Downloads/Terr316/Terr316_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr316_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr316/Terr316_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr316_RUBridge);

-- ** END AttachDBs **********;


-- ** FixPinewood **********
-- *	5/8/21.	wmk.
-- *--------------------------
-- *
-- * FixPinewood - Fix Pinewood records.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes.
-- *;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr316_SCBridge
WHERE OWNINGPARCEL IS "0403050049")
UPDATE Terr316_RUBridge 
SET OWNINGPARCEL = 
CASE
WHEN SUBSTR(UnitAddress,1,3) IS "504"
  OR  SUBSTR(UnitAddress,1,3) IS "508"
  OR  SUBSTR(UnitAddress,1,3) IS "510"
  OR  SUBSTR(UnitAddress,1,3) IS "512"
 THEN "0403050049"
ELSE OwningParcel
END,
SitusAddress = 
CASE 
WHEN SUBSTR(UnitAddress,1,3) IS "504"
  OR  SUBSTR(UnitAddress,1,3) IS "508"
  OR  SUBSTR(UnitAddress,1,3) IS "510"
  OR  SUBSTR(UnitAddress,1,3) IS "512"
 THEN (SELECT Situs FROM a 
  WHERE OWNINGPARCEL IS "0403050049"
  )
ELSE SitusAddress
END,
Phone2 =
CASE 
WHEN SUBSTR(UnitAddress,1,3) IS "504"
  OR  SUBSTR(UnitAddress,1,3) IS "508"
  OR  SUBSTR(UnitAddress,1,3) IS "510"
  OR  SUBSTR(UnitAddress,1,3) IS "512"
 THEN (SELECT Hstead FROM a 
  WHERE OWNINGPARCEL IS "0403050049"
  )
ELSE Phone2
END,
PropUse = 
CASE 
WHEN SUBSTR(UnitAddress,1,3) IS "504"
  OR  SUBSTR(UnitAddress,1,3) IS "508"
  OR  SUBSTR(UnitAddress,1,3) IS "510"
  OR  SUBSTR(UnitAddress,1,3) IS "512"
 THEN (SELECT UseType FROM a 
  WHERE OWNINGPARCEL IS "0403050049"
  )
ELSE PropUse
END,
DoNotCall = 
CASE 
WHEN SUBSTR(UnitAddress,1,3) IS "504"
  OR  SUBSTR(UnitAddress,1,3) IS "508"
  OR  SUBSTR(UnitAddress,1,3) IS "510"
  OR  SUBSTR(UnitAddress,1,3) IS "512"
 THEN (SELECT DNC FROM a 
  WHERE OWNINGPARCEL IS "0403050049"
  )
ELSE DoNotCall
END,
RSO = 
CASE 
WHEN SUBSTR(UnitAddress,1,3) IS "504"
  OR  SUBSTR(UnitAddress,1,3) IS "508"
  OR  SUBSTR(UnitAddress,1,3) IS "510"
  OR  SUBSTR(UnitAddress,1,3) IS "512"
 THEN (SELECT SCSO FROM a 
  WHERE OWNINGPARCEL IS "0403050049"
  )
ELSE RSO
END,
"Foreign" =
CASE 
WHEN SUBSTR(UnitAddress,1,3) IS "504"
  OR  SUBSTR(UnitAddress,1,3) IS "508"
  OR  SUBSTR(UnitAddress,1,3) IS "510"
  OR  SUBSTR(UnitAddress,1,3) IS "512"
 THEN (SELECT FL FROM a 
  WHERE OWNINGPARCEL IS "0403050049"
  )
ELSE "Foreign"
END,
RecordType = 
CASE 
WHEN SUBSTR(UnitAddress,1,3) IS "504"
  OR  SUBSTR(UnitAddress,1,3) IS "508"
  OR  SUBSTR(UnitAddress,1,3) IS "510"
  OR  SUBSTR(UnitAddress,1,3) IS "512"
 THEN (SELECT RecType FROM a 
  WHERE OWNINGPARCEL IS "0403050049"
  )
ELSE RecordType
END
WHERE UnitAddress LIKE "5__   PINEWOOD%" 
 AND OWNINGPARCEL IS "-";
 
-- ** END FixPinewood **********;


-- ** Fix1505Colonia **********
-- *	5/8/21.	wmk.
-- *--------------------------
-- *
-- * Fix1505Colonia - Fix 1505 Colonia Ln.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes. 1505 Colonia Ln is actually part of 513 ShadyLawn
-- *;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr316_SCBridge
WHERE StreetAddr LIKE "513   SHADYLAWN%")
UPDATE Terr316_RUBridge
SET OwningParcel = "0403050055",
SitusAddress = (SELECT Situs FROM a 
  WHERE OWNINGPARCEL IS "0403050055"
  ),
Phone2 =(SELECT Hstead FROM a 
  WHERE OWNINGPARCEL IS "0403050055"
  ),
PropUse = (SELECT UseType FROM a 
  WHERE OWNINGPARCEL IS "0403050055"
  ),
DoNotCall = (SELECT DNC FROM a 
  WHERE OWNINGPARCEL IS "0403050055"
  ),
RSO = (SELECT SCSO FROM a 
  WHERE OWNINGPARCEL IS "0403050055"
  ),
"Foreign" =(SELECT FL FROM a 
  WHERE OWNINGPARCEL IS "0403050055"
  ),
RecordType = "M"
WHERE UnitAddress LIKE "1505   COLONIA%"; 

-- ** END Fix1505Colonia **********;


--begin SPLIT
--begin FixFromSC
-- ** FixFromSC **********
-- *	5/8/21.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 316.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr316_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr316_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 316
-- *	Terr316_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr316_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr316_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr316_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr316_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Fix records not fixed above.
-- *;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr316_SCBridge)
UPDATE Terr316_RUBridge
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
-- ** END FiX316RU **********;

-- ** DelStrays **********
-- *	5/8/21.	wmk.
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
DELETE FROM Terr316_RUBridge 
WHERE UnitAddress LIKE "%%";

-- ** END DelStrays **********;


-- ** FixWhatever **********
-- *	5/8/21.	wmk.
-- *--------------------------
-- *
-- * FixWhatever - Fix whatever for territory 122.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr316_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr316_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr316_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr316_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr316_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Whatever
-- *;

-- * DBs attached above;

* modify this WITH to match;
WITH a AS (SELECT "Account #" AS Acct, 
"situs address (property address)" AS Situs,
"780   TAMIAMI TRL S"
 AS StreetAddr,
"property use code" AS UseType FROM Terr86777
WHERE Situs LIKE "%780E  FIRENZE%"
)
UPDATE Terr316_RUBridge
SET OwningParcel = 
CASE 
WHEN 
 THEN (SELECT Acct FROM a 
  WHERE 
  )
ELSE OwningParcel
END,
SitusAddress = 
CASE 
WHEN 
 THEN (SELECT Situs FROM a 
  WHERE 
  )
ELSE SitusAddress
END,
PropUse = 
CASE 
WHEN 
 THEN (SELECT UseType FROM a 
  WHERE 
  )
ELSE SitusAddress
END,
RecordType = 
CASE 
WHEN 
 THEN "M"  or C or something
ELSE RecordType
END
WHERE OwningParcel is "-" 
   AND Whatever;

-- ** END FixWhatever **********;


-- ** subquery **********
-- *	5/8/21.	wmk.
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
-- ** END Fi316xRU **********;
