-- Fix217RU.sql - Fix RU parcels in territory 217.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * .   wmk.   (automated) udpate FixFromSC (Terr124 template).
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
--	8/28/21.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 8/27/21.	wmk.	original code (compatible with make).
-- * 8/28/21.	wmk.	added FixFromSC query.
-- *
-- * Notes. whatever relevant for this RU download..
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * FixWhatever - Fix whatever for territory 217.
-- *;

-- ** AttachDBs **********
-- *	8/27/21.	wmk.
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
-- *	Terr217_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr217_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 217
-- *	Terr217_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr217_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr217_RUPoly)
-- *
-- * Exit DB and table results.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/27/21.	wmk.	modified for cross-system use; dependency on
-- *					folderbase env var.
-- * Notes.
-- *;

-- * junk as main;
-- * folderbase = /home/bill for Kay's system;
-- * folderbase = /media/ubuntu/Windows/Users/Bill for home system.
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
 ||		'/RawData/SCPA/SCPA-Downloads/Terr217/Terr217_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr217_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr217/Terr217_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr217_RUBridge);

-- ** END AttachDBs **********;

-- ** FixWhatever **********
-- *	8/29/21.	wmk.
-- *--------------------------
-- *
-- * FixWhatever - Fix whatever for territory 217.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr217_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr217_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr217_RUPoly)
-- *			imported from Map217_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr217_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr217_RUBridge - Bridge records fixed where..
-- *
-- * Modification History.
-- * ---------------------
-- * 8/27/21.	wmk.	original code.
-- * 8/29/21.	wmk.	Notes added and 1307 Pinebrook Way changed to 1307
-- * Pinebrook Way Ct.
-- *
-- * Notes. 1307 Pinebrook Way and 1307 Pinebrook Way Ct are the same house.
-- * Postal address 1307 Pinebrook Way has zip+4, 1307 Pinebrook Way Ct only
-- * has zip. For now, we will use Ct, since that is the county record, and
-- * likely mail will get delivered and not returned.
-- *;

-- * DBs attached above;
-- * Terr86777.db as db2;
-- * Terr217_RU.db as db12;
-- * Terr217_SC.db as db11;

UPDATE Terr217_RUBridge
SET UnitAddress = TRIM(UnitAddress) || ' Ct'
WHERE TRIM(UnitAddress) IS '1307   Pinebrook Way';

WITH a AS (select "ACCOUNT #" AS Acct,
  "situs address (property Address)" AS Situs,
  "property use code" AS UseType
  from Terr86777
	where "situs address (property Address)"
	 like '1307   pinebrook way%' 
	   or "situs address (property Address)"
	 like '1331   pinebrook way%'
	   or "account#" IS '0404080017')
UPDATE Terr217_RUBridge 
SET OWNINGPARCEL =
CASE 
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT Situs FROM a) 
 THEN (select Acct from a 
  where Situs IS UPPER(TRIM(UnitAddress)) )
ELSE OWNINGPARCEL
END,
SITUSADDRESS = 
CASE
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT Situs FROM a) 
 THEN (select Situs from a 
  where Situs IS UPPER(TRIM(UnitAddress)) )
ELSE SITUSADDRESS
END,
PROPUSE =
CASE 
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT Situs FROM a) 
 THEN (select UseType from a 
  where Situs IS UPPER(TRIM(UnitAddress)) )
ELSE PROPUSE
END,
RECORDTYPE =
CASE
WHEN UPPER(TRIM(UnitAddress)) IN (SELECT Situs FROM a) 
 THEN "P"
ELSE RECORDTYPE
END
WHERE OwningParcel IS "-";
-- ** END FixWhatever **********;

--begin SPLIT
--begin FixFromSC
-- ** FixFromSC **********
-- *	8/28/21.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 217.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr217_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr217_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr213_RUPoly)
-- *			imported from Map217_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr217_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr217_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Fix records not fixed with FixWhatever above.
-- *;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr217_SCBridge)
UPDATE Terr217_RUBridge
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
-- ** END Fix217RU **********;
