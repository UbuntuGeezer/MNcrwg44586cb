--Fix213RU.sql - Fix RU parcels in territory 213.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * .   wmk.   (automated) udpate FixFromSC (Terr213 template).
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
-- * 1/13/22.	wmk.	(automated) ($)string repairs.
-- *  6/12/21.	wmk.	(automated) ($)folderbase support.
--	4/21/21.	wmk.
--
-- * Modification History.
-- * 4/21/21.	wmk.	original code (compatible with make).
-- *
-- * Notes. 213 contains 950 Ridgewood, an ALF. This query sets the
-- * parcel ID, then updates all the records from the SC data.
-- *;

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * DelStrays - Delete stray records from RU download.
-- * Fix950Pinebrook - Fix records for 950 PINEBROOK ALF.
-- * FixFromSC - Fix RU records from SC records for territory 122.
-- *;

-- ** AttachDBs **********
-- *	4/21/21.	wmk.
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
-- *	Terr213_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr213_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 213
-- *	Terr213_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr213_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr213_RUPoly)
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
 ||		'/RawData/SCPA/SCPA-Downloads/Terr213/Terr213_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr213_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr213/Terr213_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr213_RUBridge);

-- ** END AttachDBs **********;


-- ** DelStrays **********
-- *	4/21/21.	wmk.
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
--DELETE FROM Terr213_RUBridge 
--WHERE UnitAddress LIKE "%%";

-- ** END DelStrays **********;


-- ** Fix950Pinebrook **********
-- *	4/21/21.	wmk.
-- *--------------------------
-- *
-- * Fix950Pinebrook - Fix records for 950 PINEBROOK ALF.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr213_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr213_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr213_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr213_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr213_RUBridge - Bridge records fixed where..
-- *
-- * Notes. Whatever
-- *;

-- * DBs attached above;

-- * set up with data from SCBridge;
WITH a AS (SELECT OwningParcel AS Acct, 
SitusAddress AS Situs,
UnitAddress AS StreetAddr,
PropUse AS UseType FROM Terr86777
WHERE StreetAddr LIKE "950  PINEBROOK%"
)
UPDATE Terr213_RUBridge
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
PropUse = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a)
 THEN (SELECT UseType FROM a 
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE PropUse
END,
RecordType = "M"
WHERE UnitAddress LIKE "950   PINEBROOK%";

-- ** END Fix950Pinebrook **********;


--begin FixFromSC
-- ** FixFromSC **********
-- *	6/24/22.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 213.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr213_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr213_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 213
-- *	Terr213_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr213_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr213_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr213_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr213_RUBridge - Bridge records fixed where..
-- *
-- * Modification History.
-- * 5/19/21.	wmk.	original code.
-- * 6/22/22.	wmk.	total overhaul; fix day 1 bug where addresses with units
-- *			 all getting same parcel ID.
-- * 6/24/22.	wmk.	bug fix where no ELSEs when setting OwningParcel.
-- *
-- * Notes. Fix owning parcels then other fields.
-- *;

-- * DBs attached above;
-- * Terr213_SC.db db11;
-- * Terr213_RU.db db12;

-- * first fix OwningParcels where there are units;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Unit AS SCUnit,
Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr213_SCBridge)
UPDATE Terr213_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
    IN (SELECT StreetAddr FROM a
	 WHERE SCUnit IS Unit
	)
    THEN (SELECT Acct FROM a 
    WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
      AND SCUnit IS UNIT
	)
ELSE OwningParcel
END
WHERE "OwningParcel" is "-"
  AND LENGTH(Unit) > 0;

-- * then fix OwningParcels with no units;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr213_SCBridge)
UPDATE Terr213_RUBridge
SET OwningParcel = 
CASE 
WHEN UPPER(TRIM(UnitAddress))
    IN (SELECT StreetAddr FROM a)
   THEN (SELECT Acct FROM a 
    WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
ELSE OwningParcel
END
WHERE "OwningParcel" is "-"
  AND LENGTH(Unit) = 0;

-- * now set remaining fields from SC data;
-- *  SitsusAddress, Phone2, DoNotCall, RSO, Foreign;
-- *  RecordType;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr213_SCBridge)
UPDATE Terr213_RUBridge
SET SitusAddress = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT Situs FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE SitusAddress
END,
Phone2 =
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT Hstead FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE Phone2
END,
PropUse = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT UseType FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE PropUse
END,
DoNotCall = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT DNC FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE DoNotCall
END,
RSO = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT SCSO FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE RSO
END,
"Foreign" =
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT FL FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE "Foreign"
END,
RecordType = 
CASE 
WHEN OwningParcel
 IN (SELECT Acct FROM a)
 THEN (SELECT RecType FROM a 
  WHERE Acct IS OwningParcel
  )
ELSE RecordType
END; 
-- ** END FixFromSC **********;
--/**/

-- ** END FixFromSC **********;
--/**/


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
-- ** END Fix213RU **********;



