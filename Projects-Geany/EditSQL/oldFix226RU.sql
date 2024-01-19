--FixX226RU.sql - Fix RU parcels in territory 226.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * .   wmk.   (automated) udpate FixFromSC (Terr124 template).
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
--	9/24/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 4/26/21.	wmk.	original code (compatible with make).
-- * 6/12/21.	wmk.	(automated) ($)folderbase support.
-- * 9/24/21.	wmk.	$ reverted back to % in strings.
-- *
-- * Notes. whatever relevant for this RU download..
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * DelStrays - Delete stray records from RU download.
-- * FixWhatever - Fix whatever for territory 122.
-- *;

-- ** AttachDBs **********
-- *	4/26/21.	wmk.
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
-- *	Terr226_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr226_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 226
-- *	Terr226_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr226_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr226_RUPoly)
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
 ||		'/RawData/SCPA/SCPA-Downloads/Terr226/Terr226_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr226_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr226/Terr226_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr226_RUBridge);

-- ** END AttachDBs **********;



--begin SPLIT
--begin FixFromSC
-- ** FixFromSC **********
-- *	4/26/21.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 122.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr226_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr226_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr213_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr226_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr226_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Fix records not fixed with 950 Pinebrook above.
-- *;

-- * DBs attached above;

WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr226_SCBridge)
UPDATE Terr226_RUBridge
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
-- ** END Fix226RU.sql **********;
