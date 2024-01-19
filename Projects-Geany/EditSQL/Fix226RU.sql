--FixX226RU.sql - Fix RU parcels in territory 226.
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- * .   wmk.   (automated) udpate FixFromSC (Terr226 template).
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



--begin FixFromSC
-- ** FixFromSC **********
-- *	6/24/22.	wmk.
-- *----------------------
-- *
-- * FixFromSC - Fix RU records from SC records for territory 226.
-- *
-- * Entry DB and table dependencies.
-- *	Terr86777.db - as db2, SCPA data for NV territory
-- *		Terr86777 - SCPA property records
-- *	Terr226_SC.db - as db11, new territory records from SCPA polygon
-- *		Terr226_SCBridge - Bridge formatted records extracted from SCPA
-- *			for territory 226
-- *	Terr226_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr226_RUBridge - sorted Bridge formatted records extracted 
-- *			from RefUSA polygon (see Terr226_RUPoly)
-- *			imported from Map122_RU.csv in folder RefUSA-Downloads
-- *
-- * Exit DB and table results.
-- *	Terr226_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terr226_RUBridge - Bridge records fixed where..
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
-- * Terr226_SC.db db11;
-- * Terr226_RU.db db12;

-- * first fix OwningParcels where there are units;
WITH a AS (SELECT OwningParcel AS Acct, 
UnitAddress As StreetAddr, Unit AS SCUnit,
Phone2 AS Hstead,
SitusAddress AS Situs,
DoNotCall AS DNC, RSO AS SCSO, "Foreign" AS FL,
PropUse AS UseType, RecordType AS RecType
FROM db11.Terr226_SCBridge)
UPDATE Terr226_RUBridge
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
FROM db11.Terr226_SCBridge)
UPDATE Terr226_RUBridge
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
FROM db11.Terr226_SCBridge)
UPDATE Terr226_RUBridge
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
-- ** END Fix226RU.sql **********;
