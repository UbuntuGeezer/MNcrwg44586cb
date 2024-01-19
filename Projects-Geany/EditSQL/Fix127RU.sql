--Fix127RU.sql - Production fix RU parcels territory 127.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * 7/9/22.   wmk.   (automated) udpate FixFromSC (Terr127 template).
-- * 6/2/22.     wmk.   (automated) NVenAll > Terr86777.
--	9/22/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 3/12/21.	wmk.	original code (compatible with make).
-- * 5/14/21.	wmk.	FixFromSC added.
-- * 6/12/21.	wmk.	(automated) ($)folderbase support.
-- *
-- * Notes. whatever relevant for this RU download..
-- *;

-- * Notes. In the original version of Fix127RU, several
-- * methods were used to match up the RU data with the SC data.
-- * Those methods have been preserved in the legacy folder /Previous.
-- * This new query uses a generic algorithm that will carry through
-- * for post-procesing downloads into Bridge tables. After
-- * RUTidyTerr_db.sh has run, there may still be parcels that are
-- * missing parcel IDs (OwningParcel) or other information. 
-- * The generic algorithm here will attempt to resolve those issues
-- * by using the legacy Terr127_RU.db that is in the /Previous folder.
-- * If they are still unresolved after this, a file MissingIDs.csv
-- * will be the result of a query run on the Bridge table to report
-- * any UnitAddress/Unit that still does not have an assigned parcel.

-- *  Database dependencies.
-- *	junk.db - as main, junk database so can use dbxx ATTACHes
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr127_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr127_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr127_RUPoly)
-- *	Terr127_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr127_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr127_RUPoly)
-- *	
-- *		AddrXcpt - address exceptions

-- * subquery list.
-- * --------------
-- * Note: Since these are all batched, they need to be in the
-- * same order below.
-- * AttachDatabases - Attach databases for module queries.
-- * FixFromSC - Fix RU records from SC records for territory 127.
-- * FixFromPrevious - Fix RU records from previous db cycle.
-- *;

-- ** AttachDatabases~ **********
-- *	3/12/21.	wmk.
-- *--------------------------
-- *
-- * AttachDatabases - Attach databases for module queries.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr127_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr127_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr127_RUPoly)
-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
-- *	Terr127_RU.db - as db22, territory records from RefUSA polygon
-- *		Terr127_RUBridge - previous formatted records extracted 
-- *
-- * Exit DB and table results.s
-- *	see modules below

-- * junk as main;
.open '$pathbase/DB-Dev/junk.db'


ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
 AS db2;
--pragma db2.table_info(Terr86777);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr127/Terr127_RU.db'
  AS db12;
--  PRAGMA db12.table_info(Terr127_RUBridge);

ATTACH '$pathbase'
 ||		'/DB-Dev/AuxSCPAData.db'
  AS db8;
--SELECT tbl_name FROM db8.sqlite_master;
--pragma db8.table_info(AddrXcpt); 

ATTACH '$pathbase'
 ||		'/RawData/SCPA/SCPA-Downloads/Terr127/Previous/Terr127_SC.db'
  AS db21;
--  PRAGMA db21.table_info(Terr127_SCBridge);

ATTACH '$pathbase'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Terr127/Previous/Terr127_RU.db'
  AS db22;
--  PRAGMA db22.table_info(Terr127_RUBridge);


--begin FixFromSC
-- ** FixFromSC **********
-- *	6/24/22.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 127.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr127_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr127_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 127
-- *	Terr127_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr127_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr127_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr127_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr127_RUBridge - Bridge records fixed where..
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
-- * Terr127_SC.db db11;
-- * Terr127_RU.db db12;

-- * first fix OwningParcels where there are units;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Unit AS SCUnit,
Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr127_SCBridge)
UPDATE Terr127_RUBridge
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
FROM db11.Terr127_SCBridge)
UPDATE Terr127_RUBridge
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
FROM db11.Terr127_SCBridge)
UPDATE Terr127_RUBridge
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

.quit
-- *************************************************

-- ** FixFromPrevious **********
-- *	mm/dd/yy.	wmk.
-- *--------------------------
-- *
-- * FixFromPrevious - Fix RU records from previous db cycle.
-- *
-- * Entry DB and table dependencies.
-- *	Terr127_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr127_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr127_RUPoly)
-- *	Terr127_RU.db - as db22, territory records from RefUSA polygon
-- *		Terr127_RUBridge - previous formatted records extracted 
-- *
-- * Exit DB and table results.
-- *	Terr127_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr127_RUBridge - updated records where information taken
-- *		  from previous database cycle.
-- *
-- * Notes. This query runs the current Bridge against the previous Bridge
-- * attempting to pick up OwningParcel information from the previous cycle.
-- * any parcels that have been missed during this pass will be summarized
-- * on file MissingIDs.csv in the territory download folder.
-- *;

-- * databases opened above;
WITH a AS (SELECT OwningParcel AS PropID, TRIM(UnitAddress) AS StreetAddr, 
 Unit AS OldUnit, Phone2 AS Hstead, SitusAddress AS Situs, PropUse AS UseType, 
 RecordType AS RecType, DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL
 FROM db22.Terr127_RUBridge)
UPDATE db12.Terr127_RUBridge
SET OwningParcel = 
CASE 
WHEN trim(UnitAddress) IN (SELECT StreetAddr FROM a
 WHERE OldUnit IS Unit)
 THEN (SELECT PropID FROM a 
  WHERE StreetAddr IS trim(UnitAddress)
   AND Unit IS OldUnit
 ) 
ELSE OwningParcel
END, 
Phone2 =
CASE 
WHEN trim(UnitAddress) IN (SELECT StreetAddr FROM a
 WHERE OldUnit IS Unit)
 THEN (SELECT Hstead FROM a 
  WHERE StreetAddr IS trim(UnitAddress)
   AND Unit IS OldUnit
 ) 
ELSE Phone2
END, 
SitusAddress = 
CASE 
WHEN trim(UnitAddress) IN (SELECT StreetAddr FROM a
 WHERE OldUnit IS Unit)
 THEN (SELECT Situs FROM a 
  WHERE StreetAddr IS trim(UnitAddress)
   AND Unit IS OldUnit
 ) 
ELSE SitusAddress
END, 
RecordType = 
CASE 
WHEN trim(UnitAddress) IN (SELECT StreetAddr FROM a
 WHERE OldUnit IS Unit)
 THEN  (SELECT RecType FROM a
   WHERE StreetAddr IS trim(UnitAddress)
   AND Unit IS OldUnit
)
ELSE RecordType
END, 
PropUse = 
CASE 
WHEN trim(UnitAddress) IN (SELECT StreetAddr FROM a
 WHERE OldUnit IS Unit)
 THEN (SELECT UseType FROM a
   WHERE StreetAddr IS trim(UnitAddress)
   AND Unit IS OldUnit
 )
ELSE PropUse
END,
DoNotCall = 
CASE 
WHEN trim(UnitAddress) IN (SELECT StreetAddr FROM a
 WHERE OldUnit IS Unit)
 THEN (SELECT DNC FROM a
   WHERE StreetAddr IS trim(UnitAddress)
   AND Unit IS OldUnit
 )
ELSE DoNotCall
END,
RSO =
CASE 
WHEN trim(UnitAddress) IN (SELECT StreetAddr FROM a
 WHERE OldUnit IS Unit)
 THEN (SELECT SCSO FROM a
   WHERE StreetAddr IS trim(UnitAddress)
   AND Unit IS OldUnit
 )
ELSE RSO
END,
"Foreign" =
CASE 
WHEN trim(UnitAddress) IN (SELECT StreetAddr FROM a
 WHERE OldUnit IS Unit)
 THEN (SELECT FL FROM a
   WHERE StreetAddr IS trim(UnitAddress)
   AND Unit IS OldUnit
 )
ELSE "Foreign"
END 
WHERE OwningParcel is "-";

-- ** END FixFromPrevious **********;

-- * all done;
.quit
