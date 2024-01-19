-- * Fix310RU.sql - Fix RU parcels in territory 310.
-- *	7/9/22.	wmk.
-- * 7/9/22.   wmk.   (automated) udpate FixFromSC (Terr124 template).
-- *
-- * Modification History.
-- * ---------------------
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 6/2/22.    wmk.    (automated) NVenAll > Terr86777.
-- * 7/9/22.	wmk.	comments tidied.
-- * Legacy mods.	
-- * 4/23/21.	wmk.	original code (compatible with make).
-- * 6/12/21.	wmk.	(automated) ($)folderbase support.
-- * 9/14/21.	wmk.	edited for territory 310.
-- * 1/13/22.	wmk.	(automated) ($)string repairs.
-- * 
-- * Notes.
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * DelStrays - Delete stray records from RU download.
-- * FixJacaranda - Fix Jacaranda RU records territory 310.
-- * FixXcpt - Fix exceptions in RU records territory 310.
-- * FixFromSC - Fix RU records from SC records for territory 310.
-- *;

-- ** AttachDBs **********
-- *	6/2/22.	wmk.
-- *----------------------
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
-- *	Terr310_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr310_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 310
-- *	Terr310_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr310_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr310_RUPoly)
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
 ||		'/RawData/SCPA/SCPA-Downloads/Terr310/Terr310_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr310_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr310/Terr310_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr310_RUBridge);

-- ** END AttachDBs **********;


-- ** FixFromSC **********
-- *	4/23/21.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 310.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr310_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr310_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr213_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr310_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr310_RUBridge - Bridge records fixed where..
-- *
-- * Modification History.
-- * ---------------------
-- * 4/23/21.	wmk.	original code.
-- * 9/14/21.	wmk.	edited for territory 310.
-- *;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr310_SCBridge)
UPDATE Terr310_RUBridge
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

.quit
-- ** END FiX310RU **********;


-- ** FixWhatever **********
-- *	4/23/21.	wmk.
-- *--------------------------
-- *
-- * FixWhatever - Fix whatever for territory 122.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr310_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr310_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr310_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr310_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr310_RUBridge - Bridge records fixed where..
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
UPDATE Terr310_RUBridge
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
-- *	3/25/21.	wmk.
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
-- ** END Fix310RU **********;



