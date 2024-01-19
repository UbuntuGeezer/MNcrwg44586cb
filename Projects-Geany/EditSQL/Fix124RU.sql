-- * Fix124RU.sql - Fix RU records territory 124.
-- *  6/24/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 6/2/22.    wmk.    (automated) NVenAll > Terr86777.
-- * 6/12/22.	wmk.	comments tidied.
-- * 6/22/22.	wmk.	bug fix day 1 addresses with units all getting same
-- *			 parcel ID; conditional added to FixFromSC. queries;
-- * 6/24/22.	wmk.	bug fix in code for no units check.
-- *
-- * Legacy mods.
-- * 5/19/21.	wmk.	original code.
-- * 6/12/21.	wmk.	(automated) ($)folderbase support.
-- * 12/4/21.	wmk.	addendum edited for fixing with unit numbers.
-- * 12/22/21.	wmk.	$ reverted to % in strings.

-- * subquery list.
-- * --------------
-- * AttachDBs - Attach required databases.
-- * FixFromSC - Fix RU records from SC records for territory 124.
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
-- *	TerrIDData.db - as db4, territory and subterritories (all) defs
-- *		Territory - territory id definitions
-- *		SubTerrs - subterritory definitions
-- *		DoNotCalls - DoNotCall addresses by territory
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *		SitusDups - table of ambiguous situs addresses with account #s
-- *		SitusConv - situs conversion table unitaddress <-> scpa situs
-- *		AddrXcpt - address exceptions
-- *	Terr124_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr124_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 124
-- *	Terr124_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr124_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr124_RUPoly)
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
 ||		'/RawData/SCPA/SCPA-Downloads/Terr124/Terr124_SC.db'
  AS db11;
--  PRAGMA db11.table_info(Terr124_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr124/Terr124_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr124_RUBridge);

-- ** END AttachDBs **********;


-- ** DelStrays **********
-- *	5/19/21.	wmk.
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

-- * Set DelPending on all 111 Airport Ave W records.
UPDATE Terr124_RUBridge
SET DelPending = 1
WHERE UnitAddress LIKE "111   Airport%";

DELETE FROM Terr124_RUBridge 
WHERE DelPending IS 1;

-- ** END DelStrays **********;

--begin FixFromSC
-- ** FixFromSC **********
-- *	6/24/22.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 124.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr124_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr124_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 124
-- *	Terr124_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr124_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr124_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr124_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr124_RUBridge - Bridge records fixed where..
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
-- * Terr124_SC.db db11;
-- * Terr124_RU.db db12;

-- * first fix OwningParcels where there are units;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Unit AS SCUnit,
Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr124_SCBridge)
UPDATE Terr124_RUBridge
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
FROM db11.Terr124_SCBridge)
UPDATE Terr124_RUBridge
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
FROM db11.Terr124_SCBridge)
UPDATE Terr124_RUBridge
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

.quit
-- ** END Fix124RU.sql
-- ************** abandoned code 6/22/22. *****************************;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM Terr124_SCBridge)
UPDATE Terr124_RUBridge
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
-- * DO NOT DELETE - BELOW IS TEMPLATE FOR FixFromSCUnit
-- *****************************************************
-- ** FixFromSCUnit **********
-- *	mm/dd/yy.	wmk.
-- *--------------------------
-- *
-- * FixFromSCUnit - Fix RU data from SC data same address/unit
-- *
-- * Entry DB and table dependencies.
-- *   
-- *	Terrxxx_SC.db - as db11, new territory records from SCPA polygon
-- *		Terrxxx_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 124
-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terrxxx_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terrxxx_RUPoly)
-- *
-- * Exit DB and table results.
-- *
-- * Notes. This fixes fields OwningpParcel SitusAddress, PropUse, RecordType,
-- * DONOTCALL, RSO and Foreign from the SC data for the territory.
-- *;

-- * Attach databases.
-- * Terrxxx_RU.db - RU records for territory
-- * Terrxxx_SC.db - SC records for territory

-- * Use Terrxxx_SCBridge to update Terrxxx_RU records.
WITH a AS (SELECT OwningParcel AS PropID, TRIM(UnitAddress) AS StreetAddr,
 Unit AS SCUnit, SitusAddress AS Situs, PropUse AS UseType,
 DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL, RecordType AS RecType
 FROM Terrxxx_SCBridge )
UPDATE Terrxxx_RUBridge
SET OwningParcel = (SELECT PropID FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS UNIT),
 SitusAddress =
  (SELECT Situs FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS UNIT),
 PropUse = 
  (SELECT UseType FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS UNIT),
 RecordType = 
  (SELECT RecType FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS UNIT),
 DoNotCall = 
  (SELECT DNC FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS UNIT),
 RSO = 
  (SELECT SCSO FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS UNIT),
 "Foreign" = 
 (SELECT FL FROM a
  WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
   AND SCUnit IS UNIT)
WHERE UPPER(TRIM(UnitAddress))
 IN (SELECT StreetAddr FROM a 
   WHERE SCUnit IS Unit);

-- * end FixFromSCUnit
-- ** END Fix124RU **********;
-- * first fix OwningParcels where there are units;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, UnitAS SCUnit,
Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr124_SCBridge)
UPDATE Terr124_RUBridge
SET OwningParcel = 
 CASE
 WHEN (SELECT Count(unit) FROM Terr124_RUBridge
      WHERE LENGTH(UNit) > 0 ) > 0
  then
  CASE 
   WHEN UPPER(TRIM(UnitAddress))
    IN (SELECT StreetAddr FROM a)
    THEN (SELECT Acct FROM a 
    WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
      AND SCUnit IS UNIT
  )
  END
END
WHERE "OwningParcel" is "-";

-- * then fix OwningParcels with no units;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr124_SCBridge)
UPDATE Terr124_RUBridge
SET OwningParcel = 
CASE
WHEN (SELECT Count(unit) FROM Terr124_RUBridge
      WHERE LENGTH(UNit) > 0 ) > 0
 then
 CASE 
  WHEN UPPER(TRIM(UnitAddress))
    IN (SELECT StreetAddr FROM a)
   THEN (SELECT Acct FROM a 
    WHERE StreetAddr IS UPPER(TRIM(UnitAddress))
  )
  END
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
FROM db11.Terr124_SCBridge)
UPDATE Terr124_RUBridge
SET SitusAddress = 
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

