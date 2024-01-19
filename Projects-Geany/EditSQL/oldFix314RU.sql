--Fix314RU.sql - Fix RU parcels in territory 314.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 7/9/22.   wmk.   (automated) udpate FixFromSC (Terr124 template).
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
--	9/23/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 5/15/21.	wmk.	original code (compatible with make).
-- * 6/12/21.	wmk.	(automated) ($)folderbase support.
-- * 9/32/21.	wmk.	ensure " S" suffix on Ruby and Pearl addresses.
-- *
-- * Notes. Scotties Pl is the dividing line between N and S jewel streets.
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * FixFromSC - Fix RU records from SC records for territory 314.
-- * DelStrays - Delete stray records from RU download.
-- * FixWhatever - Fix whatever for territory 314.
-- *;

-- ** AttachDBs **********
-- *	5/15/21.	wmk.
-- *---------------------
-- *
-- * AttachDBs - Attach required databases.
-- *
-- * Entry DB and table dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	TerrIDData.db - as db4, territory and subterritories (all) defs
-- *		Territory - territory id definitions
-- *		SubTerrs - subterritory definitions
-- *		DoNotCalls - DoNotCall addresses by territory
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *		SitusDups - table of ambiguous situs addresses with account #s
-- *		SitusConv - situs conversion table unitaddress <-> scpa situs
-- *		AddrXcpt - address exceptions
-- *	Terr314_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr314_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 314
-- *	Terr314_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr314_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr314_RUPoly)
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
 ||		'/DB-Dev/TerrIDData.db'
 AS db4;
--SELECT tbl_name FROM db4.sqlite_master 
-- WHERE type is "table";
--pragma db4.table_info(DoNotCalls);

ATTACH '$pathbase'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AddrXcpt); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terr314/Terr314_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr314_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr314/Terr314_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr314_RUBridge);

-- ** END AttachDBs **********;


-- ** FixBUnits **********
-- *	5/15/21.	wmk.
-- *----------------------
-- *
-- * FixBUnits - Fix B units in Edmondson and Kilpatrick records.
-- *
-- * Entry DB and table dependencies.
-- *   <list main DB and ATTACHed DBs and tables>
-- *
-- * Exit DB and table results.
-- *
-- * Notes.
-- *;

-- * DBs attached above;

-- * Fix 2280 Edmondson Rd;
UPDATE Terr314_RUBridge
SET Unit = 
CASE
WHEN SUBSTR(UnitAddress,5,1) IS "B"
 THEN "B"
ELSE Unit
END,
UnitAddress = 
CASE
WHEN SUBSTR(UnitAddress,5,1) IS "B"
 THEN SUBSTR(UnitAddress,1,4) || SUBSTR(UnitAddress,6)
ELSE UnitAddress
END
WHERE UnitAddress LIKE "2280%EDMONDSON%";

-- * Fix 1951 Kilpatrick Rd;
UPDATE Terr314_RUBridge
SET Unit = 
CASE
WHEN SUBSTR(UnitAddress,5,1) IS "B"
 THEN "B"
ELSE Unit
END,
UnitAddress = 
CASE
WHEN SUBSTR(UnitAddress,5,1) IS "B"
 THEN SUBSTR(UnitAddress,1,4) || SUBSTR(UnitAddress,6)
ELSE UnitAddress
END
WHERE UnitAddress LIKE "1951%KILPATRICK%";


-- ** END FixBUnits **********;


-- ** FixRubyPearl **********
-- *	9/23/21.	wmk.
-- *-------------------------
-- *
-- * subquery_name - simple description.
-- *
-- * Entry DB and table dependencies.
-- *
-- * Exit DB and table results.
-- * 12	Terr314_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr314_RUBridge - Ruby and Pearl Ave,s updated 
-- *
-- * Modification History.
-- * ---------------------
-- * 9/23/21.	wmk.	original code (compatible with make).
-- *
-- * Notes. Some RU addresses for Ruby and Pearl coming through without " S" suffix.
-- *;

UPDATE Terr314_RUBridge
SET UnitAddress = 
CASE
WHEN SUBSTR(UnitAddress,LENGTH(UnitAddress)-1,2) IS NOT ' S'
 THEN UnitAddress || ' S'
ELSE UnitAddress
END
WHERE UnitAddress LIKE '%ruby%'
   OR UnitAddress LIKE '%pearl%';

-- ** END FixRubyPearl **********;


--begin SPLIT
--begin FixFromSC
-- ** FixFromSC **********
-- *	5/15/21.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 314.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr314_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr314_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 314
-- *	Terr314_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr314_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr314_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr314_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr314_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Fix records not fixed above.
-- *;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr314_SCBridge)
UPDATE Terr314_RUBridge
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
-- ** END FiX314RU **********;

-- ** DelStrays **********
-- *	5/15/21.	wmk.
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
--DELETE FROM Terr314_RUBridge 
--WHERE UnitAddress LIKE "%%";

-- ** END DelStrays **********;


-- ** FixWhatever ************
-- *	5/15/21.	wmk.
-- *--------------------------
-- *
-- * FixWhatever - Fix whatever for territory 314.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr314_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr314_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr314_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr314_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr314_RUBridge - Bridge records fixed where..
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
UPDATE Terr314_RUBridge
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
-- *	5/15/21.	wmk.
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
-- ** END Fi314xRU **********;
